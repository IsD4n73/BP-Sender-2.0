import 'dart:io';
import 'package:enough_mail/enough_mail.dart';
import 'package:buste_paga_sender/controller/files_controller.dart';
import 'package:buste_paga_sender/controller/mail_list_controller.dart';
import 'package:buste_paga_sender/page/sender.dart';
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
  if (account.email != null && account.password != null) {
    try {
      final client = SmtpClient(
        "3em.it",
        isLogEnabled: true,
      );

      var host = await getSavedHost();
      var port = await getSavedPort();

      await client.connectToServer(host, port, isSecure: true);
      await client.ehlo();
      if (client.serverInfo.supportsAuth(AuthMechanism.plain)) {
        await client.authenticate(
            account.user!, account.password!, AuthMechanism.plain);
      } else if (client.serverInfo.supportsAuth(AuthMechanism.login)) {
        await client.authenticate(
            account.user!, account.password!, AuthMechanism.login);
      } else {
        return true;
      }

      final builder = MessageBuilder.prepareMultipartAlternativeMessage(
        plainText: AppConfig.msg,
        htmlText: AppConfig.msg,
      )
        ..from = [MailAddress(null, account.email!)]
        ..to = [MailAddress(null, email)]
        ..subject = oggetto;

      var fileExist = await File("$dir\\$file").exists();
      if (fileExist && AppConfig.sendFile) {
        await builder.addFile(
            File("$dir\\$file"), MediaSubtype.applicationPdf.mediaType);
      }

      final mimeMessage = builder.buildMimeMessage();
      final sendResponse = await client.sendMessage(mimeMessage);

      logController.text += "[INVIO] ==> Email inviata a $email ($nome)\n";
      sendController.text += "$nome\n";
      return sendResponse.isFailedStatus;

      /*List<Attachment>? attachmentFile;

      if (await File("$dir\\$file").exists()) {
        attachmentFile = [
          FileAttachment(
            File("$dir\\$file"),
          )..location = Location.attachment,
        ];
      }


      final message = Message()
        ..from = Address(account.email!)
        ..recipients.add(email)
        ..subject = oggetto
        ..html = AppConfig.msg;

      if (attachmentFile != null && AppConfig.sendFile) {
        message.attachments = attachmentFile;
      }

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
      return false;*/
    } catch (e) {
      logController.text += "[ERRORE] ==> Email non inviata a $email ($nome)\n";
      print(e);
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
