import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:buste_paga_sender/common/alerts.dart';
import 'package:buste_paga_sender/controller/splitter_controller.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class SplitPage extends StatefulWidget {
  const SplitPage({super.key});

  @override
  State<SplitPage> createState() => _SplitPageState();
}

class _SplitPageState extends State<SplitPage> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      setState(() {});
                    }
                  },
                  child: const Text("Segli File"),
                ),
                const SizedBox(height: 15),
                Text(
                    "File Selezionato: ${file != null ? basename(file!.path) : ""}"),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    if (file == null) {
                      AlertUtils.showInfo(
                          "Non è stato selezionato nessun file");
                      return;
                    }
                    final cancel = BotToast.showLoading();

                    try {
                      await createSplittedDir(file!.parent.path);
                      await splitFile(file!);
                    } catch (_) {
                      AlertUtils.showError(
                          "Non è possibile dividere questo PDF, riprova.");
                    } finally {
                      cancel();
                    }
                  },
                  child: const Text("Avvia"),
                ),
              ],
            ),
          ),
        ],
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
    content: const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("PRIMA INSTALLAZIONE"),
          SizedBox(height: 5),
          Divider(),
          SizedBox(height: 5),
          Linkify(
           onOpen: (link) => print("Clicked ${link.url}!"),
           text: "1) Scaricare il file da https://github.com/UB-Mannheim/tesseract/wiki",
          ), 
          Text(
              "2) Add Tesseract path to your System Environment. i.e. Edit system variables."),
          Text("3) Download python"),
          Text("3) Run pip install pytesseract and pip install tesseract"),
          SizedBox(height: 5),
          Divider(),
          SizedBox(height: 10),
          Text("UTILIZZO"),
          Divider(),
          SizedBox(height: 5),
          Text(
              "1) Selezionare un file cliccando sul pulsante 'Seleziona File'"),
          Text("2) Cliccare sul pulsante 'Avvia' e attendere il completamento"),
          Text(
              "3) I PDF divisi saranno nella cartella 'Splitted' dove si trova il file principale"),
          SizedBox(height: 5),
          Divider(),
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
