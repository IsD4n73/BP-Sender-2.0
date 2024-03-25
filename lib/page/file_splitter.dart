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
import '../common/urls.dart';
import '../controller/settings_controller.dart';

TextEditingController namesController = TextEditingController();

class SplitPage extends StatefulWidget {
  const SplitPage({super.key});

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  File? file;
  int status = 3;
  String type = "CU";
  String dir = Directory.current.path;

  var shell = PythonShell(
    PythonShellConfig(),
  );

  @override
  void initState() {
    setState(() {
      file = null;
      status = 3;
      namesController.clear();
    });
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

                          if (result != null) {
                            file = File(result.files.single.path!);
                            if (CorrectionOcr.correction.isEmpty) {
                              final response =
                                  await http.get(Uri.parse(AppUrls.ocrFile));
                              if (response.statusCode == 200) {
                                CorrectionOcr.fromJson(
                                    jsonDecode(response.body));
                              }
                            }
                            try {
                              await http.get(
                                  Uri.parse('http://127.0.0.1:55004/stop'));
                            } catch (_) {
                              debugPrint(
                                  "Il server non è gia spento, shutdown non necessario");
                            }

                            try {
                              status = -1;
                              setState(() {});

                              while (true) {
                                try {
                                  var response = await http.get(
                                    Uri.parse('http://127.0.0.1:55004/'),
                                  );
                                  setState(() {
                                    if (response.statusCode == 200) {
                                      debugPrint(response.body.trim());
                                      status = 0;
                                    } else {
                                      status = 1;
                                    }
                                  });
                                  return;
                                } catch (e) {
                                  debugPrint("Riprovo a chiamare il servizio");
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );
                                }
                              }
                            } catch (e) {
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
                  Text(
                      "File Selezionato: ${file != null ? basename(file!.path) : ""}"),
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
                    child: TextField(
                      controller: namesController,
                      maxLines: 10,
                      readOnly: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'LOG',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: namesController.text.isEmpty
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
                                    String completeLog = namesController.text;

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
                                  await file
                                      .writeAsString(namesController.text);
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
              await Clipboard.setData(ClipboardData(text: link.url));
              AlertUtils.showInfo("Il link è stato copiato");
            },
            text:
                "1) Scaricare il file da https://github.com/UB-Mannheim/tesseract/wiki",
          ),
          const Text("2) Aggiungere Tesseract alle variabili di ambiente"),
          Linkify(
            onOpen: (link) async {
              await Clipboard.setData(ClipboardData(text: link.url));
              AlertUtils.showInfo("Il link è stato copiato");
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
          const Text(
              "2) Cliccare sul pulsante 'Avvia' e attendere il completamento"),
          const Text(
              "3) I PDF divisi saranno nella cartella 'Splitted' dove si trova il file principale"),
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
