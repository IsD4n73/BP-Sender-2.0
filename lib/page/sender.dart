import 'dart:io';
import 'package:buste_paga_sender/common/smtp_configuration.dart';
import 'package:buste_paga_sender/controller/account_controller.dart';
import 'package:buste_paga_sender/controller/sender_controller.dart';
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../common/alerts.dart';

TextEditingController logController = TextEditingController();

class SenderPage extends StatefulWidget {
  const SenderPage({Key? key}) : super(key: key);

  @override
  State<SenderPage> createState() => _SenderPageState();
}

class _SenderPageState extends State<SenderPage> {
  String dir = Directory.current.path;

  @override
  void initState() {
    super.initState();

    // get account credential
    getSavedAccount().then((value) {
      setState(() {
        AppConfig.username = value.email ?? "";
        AppConfig.password = value.password ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Invio Buste Paga",
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () async {
              var settings = await getSavedSettings();
              if (!settings.takeExeDir) {
                dir = await FilePicker.platform.getDirectoryPath(
                      dialogTitle: "Seleziona la cartella dove sono i file",
                    ) ??
                    "NULL";
                if (dir != "NULL") {
                  await sendEmails(dir);
                  setState(() {});
                }
              } else {
                await sendEmails(dir);
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width / 2, 40),
            ),
            child: const Text("Invia"),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: logController,
            maxLines: 10,
            readOnly: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'LOG',
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: logController.text.isEmpty
                  ? null
                  : () async {
                      DateTime currentDate = DateTime.now();

                      var settings = await getSavedSettings();
                      if (!settings.takeExeDir) {
                        dir = await FilePicker.platform.getDirectoryPath(
                              dialogTitle:
                                  "Seleziona la cartella dove sono i file",
                            ) ??
                            "NULL";
                        if (dir != "NULL") {
                          try {
                            final File file = File(
                                '$dir/log-${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.second}.txt');
                            await file.writeAsString(logController.text);
                            showFileSaved(dir);
                          } catch (_) {
                            showFileError();
                          }
                        }
                      } else {
                        try {
                          final File file = File(
                              '$dir/log-${currentDate.day}-${currentDate.month}-${currentDate.year}-${currentDate.second}.txt');
                          await file.writeAsString(logController.text);
                          showFileSaved(dir);
                        } catch (_) {
                          showFileError();
                        }
                      }
                    },
              child: const Text("Salva Log"),
            ),
          ),
        ],
      ),
    );
  }
}
