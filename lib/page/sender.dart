import 'dart:io';
import 'package:buste_paga_sender/controller/sender_controller.dart';
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:windows_taskbar/windows_taskbar.dart';

import '../common/alerts.dart';
import '../common/smtp_configuration.dart';

TextEditingController logController = TextEditingController();
TextEditingController sendController = TextEditingController();
TextEditingController notSendController = TextEditingController();

class SenderPage extends StatefulWidget {
  const SenderPage({super.key});

  @override
  State<SenderPage> createState() => _SenderPageState();
}

class _SenderPageState extends State<SenderPage> {
  String dir = Directory.current.path;
  List<String> listData = [];

  @override
  void initState() {
    super.initState();
    formatBody();
    getSavedAdvanced().then((value) {
      setState(() {
        listData = generateExampleList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Invio Email",
              style: TextStyle(fontSize: 32),
            ),
            Text(
                "${listData.join(AppConfig.splitSymbol)}.${AppConfig.fileExtension} ${AppConfig.sendFile == false ? "(Il file non verrà allegato)" : ""}"),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                WindowsTaskbar.setProgressMode(
                    TaskbarProgressMode.indeterminate);
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
                WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width / 2, 40),
              ),
              child: const Text(
                "Invia",
                style: TextStyle(fontSize: 16),
              ),
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
                                    "Seleziona la cartella dove salvare il file",
                              ) ??
                              "NULL";
                          if (dir != "NULL") {
                            try {
                              String completeLog = logController.text;
                              completeLog +=
                                  "\n\n======== NON INVIATE ========\n${notSendController.text}";
                              completeLog +=
                                  "\n\n======== INVIATE ========\n${sendController.text}";
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
                            await file.writeAsString(logController.text);
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
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: sendController,
                    maxLines: 5,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          'INVIATE (${'\n'.allMatches(sendController.text).length})',
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: notSendController,
                    maxLines: 5,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          'NON INVIATE (${'\n'.allMatches(notSendController.text).length})',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
