import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../model/account_model.dart';
import '../model/maillist_model.dart';
import '../page/bulk_sender.dart';
import 'account_controller.dart';

Future<void> sendBulkEmails(
    String oggetto, String body, List<MailListModel> list) async {
  bulklogController.text = "\n======== INIZIO ========\n\n";

  AccountModel account = await getSavedAccount();

  final message = Message()
    ..from = Address(account.email!)
    ..subject = oggetto
    ..recipients.add(account.email!)
    ..html = body.replaceAll("\n", "<br>");

  for (var mail in list) {
    bulklogController.text += "\n[INFO] ==> Aggiunto: ${mail.nome}";
    message.bccRecipients.add(mail.email);
  }

  var host = await getSavedHost();
  var port = await getSavedPort();

  try {
    await send(
      message,
      SmtpServer(
        host,
        password: account.password!,
        username: account.user!,
        port: port,
        allowInsecure: true,
        ignoreBadCertificate: true,
      ),
    );
  } on MailerException {
    bulklogController.text += "\n\n[ERRORE] ==> Email non inviata\n";
  }

  bulklogController.text += "\n\n======== FINE ========";
}
