import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:buste_paga_sender/common/alerts.dart';
import 'package:buste_paga_sender/controller/splitter_controller.dart';
import 'package:buste_paga_sender/model/correction_ocr.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'package:python_shell/python_shell.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../common/python_script.dart';
import '../common/urls.dart';
import '../controller/settings_controller.dart';

ValueNotifier<TextEditingController> namesController =
    ValueNotifier<TextEditingController>(TextEditingController());

class SplitPage extends StatefulWidget {
  const SplitPage({super.key});

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  File? file;
  int status = -2;
  String type = "CU";
  String dir = Directory.current.path;

  var shell = PythonShell(
    PythonShellConfig(),
  );

  @override
  void initState() {
    setState(() {
      file = null;
      status = -2;
      namesController.value.clear();
    });

    Future.delayed(
      Duration.zero,
      () async {
        await shell.initialize();
        var instance = ShellManager.getInstance("default");
        instance.installRequires(
          [
            "flask",
            "pytesseract",
          ],
          echo: true,
        );

        try {
          await http.get(Uri.parse('http://127.0.0.1:55004/stop'));
        } catch (_) {
          debugPrint("Chiusura server non necessaria");
        }

        instance.runString(
          python,
          echo: true,
          listener: ShellListener(
            onError: (p0, p1) {
              AlertUtils.showError(p1.toString());
            },
            onMessage: (p0) {
              debugPrint("ONMESSAGE: $p0");
              if (p0.contains("Serving Flask app")) {
                setState(() {
                  status = 3;
                });
              }
            },
          ),
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (status == 1) {
      AlertUtils.showError("A causa di un errore non è possibile procedere");
      return const Center(
        child: Text("Non è possibile utilizzare questa funzione al momento..."),
      );
    }

    if (status == -2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            "Attendere...",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text("Download dei file necessari in corso"),
          SizedBox(height: 50),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.height / 2, 50),
            ),
            onPressed: () {
              showGuideDialog(context);
            },
            child: const Text(
              "Guida",
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.height / 2, 50),
              ),
              onPressed: () {
                showGuideDialog(context);
              },
              child: const Text(
                "Guida",
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 5),
            SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Divisione PDF",
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 45),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ["pdf"],
                            dialogTitle: "Seleziona il file",
                          );

                          namesController.value.clear();

                          if (result != null) {
                            namesController.value.text +=
                                "\n[INFO] ==> File preso correttamente";
                            file = File(result.files.single.path!);
                            if (CorrectionOcr.correction.isEmpty) {
                              final response =
                                  await http.get(Uri.parse(AppUrls.ocrFile));
                              if (response.statusCode == 200) {
                                CorrectionOcr.fromJson(
                                    jsonDecode(response.body));
                                namesController.value.text +=
                                    "\n[INFO] ==> Correzioni caricate correttamente";
                              }
                            }

                            try {
                              status = -1;
                              int attempt = 0;
                              setState(() {});

                              while (attempt == 100) {
                                try {
                                  var response = await http.get(
                                    Uri.parse('http://127.0.0.1:55004/'),
                                  );
                                  setState(() {
                                    if (response.statusCode == 200) {
                                      debugPrint(response.body.trim());
                                      namesController.value.text +=
                                          "\n[INFO] ==> Servizio riconoscimento online, app pronta ad iniziare";
                                      status = 0;
                                    } else {
                                      status = 1;
                                    }
                                  });
                                  return;
                                } catch (e) {
                                  debugPrint("Riprovo a chiamare il servizio");
                                  namesController.value.text +=
                                      "\n[VERBOSE] ==> Servizio NON online, riprovo...";
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );
                                } finally {
                                  attempt++;
                                }
                              }
                            } catch (e) {
                              namesController.value.text +=
                                  "\n[ERRORE] ==> ${e.toString()}";
                              setState(() {
                                status = 1;
                              });
                            }

                            setState(() {});
                          }
                        },
                        child: const Text("Segli File"),
                      ),
                      const SizedBox(width: 20),
                      DropdownButton(
                        value: type,
                        items: const [
                          DropdownMenuItem(
                            value: "CU",
                            child: Text("Certificazione Unica"),
                          ),
                          DropdownMenuItem(
                            value: "BP",
                            enabled: false,
                            child: Text("Busta Paga - COOMING SOON"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            type = value ?? "CU";
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  file != null
                      ? Text("File Selezionato: ${basename(file!.path)}")
                      : const SizedBox.shrink(),
                  const SizedBox(height: 25),
                  status == 0
                      ? ElevatedButton(
                          onPressed: file == null
                              ? null
                              : () async {
                                  final cancel = BotToast.showLoading();

                                  try {
                                    await createSplittedDir(file!.parent.path);
                                    await splitFile(file!);
                                    AlertUtils.showSuccess(
                                        "La creazione di file separati è andata a buon fine!");
                                  } catch (e) {
                                    debugPrint(e.toString());
                                    AlertUtils.showError(
                                        "Non è possibile dividere questo PDF, riprova.");
                                  } finally {
                                    cancel();
                                  }
                                },
                          child: const Text("Avvia"),
                        )
                      : status == -1
                          ? const CircularProgressIndicator()
                          : const SizedBox.shrink(),
                  const SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<TextEditingController>(
                      valueListenable: namesController,
                      builder: (context, value, child) => TextField(
                        controller: value,
                        maxLines: 10,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'LOG',
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: namesController.value.text.isEmpty
                          ? null
                          : () async {
                              DateTime currentDate = DateTime.now();

                              var settings = await getSavedSettings();
                              if (!settings.takeExeDir) {
                                dir =
                                    await FilePicker.platform.getDirectoryPath(
                                          dialogTitle:
                                              "Seleziona la cartella dove salvare il file",
                                        ) ??
                                        "NULL";
                                if (dir != "NULL") {
                                  try {
                                    String completeLog =
                                        namesController.value.text;

                                    final File file = File(
                                        '$dir/log-${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.second}.txt');
                                    await file.writeAsString(completeLog);
                                    AlertUtils.showSuccess(
                                        "Il file è stato salvato in $dir");
                                  } catch (_) {
                                    AlertUtils.showError(
                                        "Non è stato possibile salvare il file");
                                  }
                                }
                              } else {
                                try {
                                  final File file = File(
                                      '$dir/log-${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.second}.txt');
                                  await file.writeAsString(
                                      namesController.value.text);
                                  AlertUtils.showSuccess(
                                      "Il file è stato salvato in $dir");
                                } catch (_) {
                                  AlertUtils.showError(
                                      "Non è stato possibile salvare il file");
                                }
                              }
                            },
                      child: const Text("Salva Log"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showGuideDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Guida Divisione PDF"),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text("PRIMA INSTALLAZIONE"),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Linkify(
            onOpen: (link) async {
              await launchUrlString(link.url);
            },
            text:
                "1) Scaricare il file da https://github.com/UB-Mannheim/tesseract/wiki",
          ),
          const Text("2) Aggiungere Tesseract alle variabili di ambiente"),
          Linkify(
            onOpen: (link) async {
              await launchUrlString(link.url);
            },
            text: "3) Scaricare python da https://www.python.org/downloads/",
          ),
          const Text(
              "4) Eseguire nel terminale:\n  - pip install pytesseract\n  - pip install tesseract"),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 10),
          const Text("UTILIZZO"),
          const Divider(),
          const SizedBox(height: 5),
          const Text(
              "1) Selezionare un file cliccando sul pulsante 'Seleziona File'"),
          const Text("2) Selezionare la tipologia del documento caricato'"),
          const Text(
              "3) Cliccare sul pulsante 'Avvia' e attendere il completamento"),
          const Text(
              "4) I PDF divisi saranno nella cartella 'Splitted' dove si trova il file principale"),
          const SizedBox(height: 5),
          const Divider(),
        ],
      ),
    ),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
