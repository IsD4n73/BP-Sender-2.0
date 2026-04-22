import 'dart:io';

import 'package:buste_paga_sender/controller/files_controller.dart';
import 'package:buste_paga_sender/controller/mail_list_controller.dart';
import 'package:buste_paga_sender/page/sender.dart';

import '../common/smtp_configuration.dart';
import '../model/account_model.dart';
import '../service/email/outlook_fallback_service.dart';
import '../service/email/smtp_delivery_service.dart';
import 'account_controller.dart';

final SmtpDeliveryService _smtpDeliveryService = SmtpDeliveryService();
final OutlookFallbackService _outlookFallbackService = OutlookFallbackService();

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
  if (account.email != null &&
      account.password != null &&
      account.user != null &&
      account.user!.isNotEmpty) {
    try {
      final host = await getSavedHost();
      final port = await getSavedPort();
      final filePath = "$dir\\$file";

      final smtpResult = await _smtpDeliveryService.send(
        account: account,
        recipient: email,
        subject: oggetto,
        htmlBody: AppConfig.msg,
        host: host,
        port: port,
        attachmentPath: filePath,
      );

      if (smtpResult.isSuccess) {
        logController.text += "[INVIO SMTP] ==> Email inviata a $email ($nome)\n";
        sendController.text += "$nome\n";
        return false;
      }

      logController.text +=
          "[ERRORE SMTP] ==> Email non inviata a $email ($nome). Dettagli: ${smtpResult.error}\n";

      if (AppConfig.useOutlookFallback) {
        final outlookResult = await _outlookFallbackService.sendViaOutlook(
          recipient: email,
          subject: oggetto,
          htmlBody: AppConfig.msg,
          attachmentPath: AppConfig.sendFile ? filePath : null,
        );

        if (outlookResult.isSent) {
          logController.text +=
              "[FALLBACK OUTLOOK] ==> Email inviata a $email ($nome). ${outlookResult.message}\n";
          sendController.text += "$nome\n";
          return false;
        }

        logController.text +=
            "[ERRORE OUTLOOK] ==> Fallback Outlook non riuscito per $email ($nome). ${outlookResult.message}\n";
        logController.text +=
            "[INFO OUTLOOK] ==> Requisiti: Outlook desktop installato, profilo configurato e consenso di sicurezza se richiesto.\n";
      }

      return true;
    } catch (e) {
      logController.text +=
          "[ERRORE] ==> Email non inviata a $email ($nome). Eccezione: $e\n";
      return true;
    }
  }

  logController.text +=
      "[ERRORE CONFIG] ==> Credenziali SMTP mancanti per inviare a $email ($nome)\n";
  return true;
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
