import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:buste_paga_sender/controller/mail_list_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../common/alerts.dart';
import '../model/maillist_model.dart';

class MailListPage extends StatefulWidget {
  const MailListPage({super.key});

  @override
  State<MailListPage> createState() => _MailListPageState();
}

class _MailListPageState extends State<MailListPage> {
  List<MailListModel> mailList = [];
  List<MailListModel> completeMailList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getMailList().then((value) {
      setState(() {
        mailList = value;
        completeMailList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  var dir = await FilePicker.platform.getDirectoryPath(
                        dialogTitle:
                            "Seleziona la cartella dove salvare il file",
                      ) ??
                      "NULL";
                  if (dir != "NULL") {
                    var cancel = BotToast.showLoading();
                    try {
                      final File file = File('$dir/emails-3EM.csv');
                      String csv = "";
                      mailList.toList().forEach((element) async {
                        csv += "${element.nome};${element.email}\n";
                      });
                      await file.writeAsString(csv);
                      AlertUtils.showSuccess("Il file è stato salvato in $dir");
                    } catch (_) {
                      AlertUtils.showError(
                          "Non è stato possibile salvare il file");
                    }
                    cancel();
                  } else {
                    AlertUtils.showError(
                        "Non è stato possibile salvare il file");
                  }
                },
                icon: const Icon(Icons.download),
                label: const Text(
                  "Scarica le email",
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              if (value.isNotEmpty || value != "") {
                setState(() {
                  mailList = completeMailList.where((element) {
                    if (element.nome
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        element.email
                            .toLowerCase()
                            .contains(value.toLowerCase())) {
                      return true;
                    } else {
                      return false;
                    }
                  }).toList();
                });
              } else {
                setState(() {
                  mailList = completeMailList;
                });
              }
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Cerca (${mailList.length})',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: mailList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: mailList.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(mailList[index].nome),
                      subtitle: Text(mailList[index].email),
                    );
                  },
                )
              : Center(
                  child: LoadingAnimationWidget.flickr(
                    leftDotColor: const Color(0xff2B6AF7),
                    rightDotColor: Colors.blueGrey,
                    size: 50,
                  ),
                ),
        ),
      ],
    );
  }
}
