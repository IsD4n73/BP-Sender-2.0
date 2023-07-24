import 'package:buste_paga_sender/controller/bulk_sender_controller.dart';
import 'package:flutter/material.dart';
import 'package:windows_taskbar/windows_taskbar.dart';
import '../controller/mail_list_controller.dart';
import '../model/maillist_model.dart';

TextEditingController bulklogController = TextEditingController();

class BulkSenderPage extends StatefulWidget {
  const BulkSenderPage({Key? key}) : super(key: key);

  @override
  State<BulkSenderPage> createState() => _BulkSenderPageState();
}

class _BulkSenderPageState extends State<BulkSenderPage> {
  List<MailListModel> mailList = [];
  TextEditingController oggetto = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  void initState() {
    super.initState();
    getMailList().then((value) {
      setState(() {
        mailList = value;
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
              "Invio Email a Mail List",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                WindowsTaskbar.setProgressMode(
                    TaskbarProgressMode.indeterminate);

                await sendBulkEmails(oggetto.text, body.text, mailList);

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
              controller: oggetto,
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Oggetto',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: body,
              maxLines: '\n'.allMatches(body.text).length + 2,
              onChanged: (value) => setState(() {}),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Corpo Email',
              ),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: bulklogController,
              maxLines: 10,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'LOG',
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
