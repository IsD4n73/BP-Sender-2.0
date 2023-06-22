import 'dart:io';

import 'package:buste_paga_sender/controller/files_controller.dart';
import 'package:buste_paga_sender/controller/mail_list_controller.dart';
import 'package:buste_paga_sender/page/sender.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../common/smtp_configuration.dart';
import '../model/account_model.dart';
import 'account_controller.dart';

Future<void> sendEmails(String dir) async {
  sendController.text = "";
  notSendController.text = "";
  logController.text = "\n======== INIZIO ========\n\n";

  await createInviateDir(dir);

  List<String> dirFiles = await getAllFileInDirectory(dir);
  Map<String, String> email = await getMailListAsMap();

  logController.text += "\n\n======== INVIO ========\n";

  for (var file in dirFiles) {
    bool sendError = false;
    logController.text += "\n[INFO] ==> Il file trovato e: $file";

    String nome = getName(file);
    String oggetto = await getOggetto(file);

    if (email[nome] != null) {
      logController.text += "\n[INFO] ==> L'email trovata e: ${email[nome]}\n";
      sendError =
          await sendMail(email[nome]!, oggetto, nome, dir, file); // send email
    } else {
      logController.text +=
          "\n[INFO-ERRORE] ==> L'email trovata e: ${email[nome]}\n";
      sendError = true;
    }

    if (!sendError) {
      final sourceFile = File("$dir\\$file");
      await sourceFile.copy("$dir\\inviate\\$file");
      await sourceFile.delete();
    } else {
      notSendController.text += "$nome\n";
    }
  }

  if (dirFiles.isEmpty) {
    logController.text +=
        "\n\nNESSUN FILE TROVATO DA CUI ESTRARRE LE INFORMAZIONI";
  }

  logController.text += "\n\n======== FINE ========";
}

Future<bool> sendMail(
    String email, String oggetto, String nome, String dir, String file) async {
  AccountModel account = await getSavedAccount();
  List<Attachment>? attachmentFile;

  if (await File("$dir\\$file").exists()) {
    attachmentFile = [
      FileAttachment(
        File("$dir\\$file"),
      )..location = Location.attachment,
    ];
  }

  if (account.email != null && account.password != null) {
    final message = Message()
      ..from = Address(account.email!)
      ..recipients.add(email)
      ..subject = oggetto
      ..html = AppConfig.msg;

    if (attachmentFile != null) {
      message.attachments = attachmentFile;
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
      logController.text += "[INVIO] ==> Email inviata a $email ($nome)\n";
      sendController.text += "$nome\n";
      return false;
    } on MailerException catch (e) {
      print(e);
      logController.text += "[ERRORE] ==> Email non inviata a $email ($nome)\n";
      return true;
    }
  }
  return false;
}

// create inviate folder
Future<void> createInviateDir(String dir) async {
  final path = Directory("$dir/inviate");
  if ((await path.exists())) {
    logController.text += "\n\n[INFO] ==> Cartella 'inviate' gia esistente\n\n";
  } else {
    path.create();
    logController.text += "\n\n[INFO] ==> Catella 'inviate' creata\n\n";
  }
}
