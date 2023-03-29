import 'package:buste_paga_sender/controller/files_controller.dart';
import 'package:buste_paga_sender/controller/mail_list_controller.dart';
import 'package:buste_paga_sender/page/sender.dart';

Future<void> sendEmails(String dir) async {
  logController.text = "\n======== INIZIO ========\n\n";

  List<String> dirFiles = await getAllFileInDirectory(dir);
  Map<String, String> email = await getMailListAsMap();

  for (var file in dirFiles) {
    logController.text += "\n[INFO] ==> Il file trovato e: $file";

    String nome = getName(file);
    String oggetto = await getOggetto(file);

    if (email[nome] != null) {
      logController.text += "\n[INFO] ==> L'email trovata e: ${email[nome]}\n";
    } else {
      logController.text +=
          "\n[INFO-ERRORE] ==> L'email trovata e: ${email[nome]}\n";
    }

    // todo send email
  }

  if (dirFiles.isEmpty) {
    logController.text +=
        "\n\nNESSUN FILE TROVATO DA CUI ESTRARRE LE INFORMAZIONI";
  }

  logController.text += "\n\n======== FINE ========";
}
