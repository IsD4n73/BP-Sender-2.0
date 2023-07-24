import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../common/smtp_configuration.dart';
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
    ..recipients.add("d.davidde@3em.it")
    ..html = body.replaceAll("\n", "<br>");

  for (var mail in list) {
    bulklogController.text += "\n[INFO] ==> Aggiunto: ${mail.nome}";
    message.bccRecipients.add(mail.email);
  }

  try {
    await send(
      message,
      SmtpServer(
        AppConfig.host,
        password: account.password!,
        username: account.user!,
        port: AppConfig.port,
        allowInsecure: true,
        ignoreBadCertificate: true,
      ),
    );
  } on MailerException {
    bulklogController.text += "\n\n[ERRORE] ==> Email non inviata\n";
  }

  bulklogController.text += "\n\n======== FINE ========";
}
