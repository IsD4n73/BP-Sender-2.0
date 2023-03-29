import 'package:buste_paga_sender/controller/mail_list_controller.dart';
import 'package:flutter/material.dart';

import '../model/maillist_model.dart';

class MailListPage extends StatefulWidget {
  const MailListPage({Key? key}) : super(key: key);

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
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mailList.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(mailList[index].nome),
                subtitle: Text(mailList[index].email),
              );
            },
          ),
        ),
      ],
    );
  }
}
