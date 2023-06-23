import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:buste_paga_sender/model/settings_model.dart';
import 'package:buste_paga_sender/page/sender.dart';

import '../common/smtp_configuration.dart';

// get the obj from file name
Future<String> getOggetto(String nomeFile) async {
  List<String> oggetto = nomeFile.split(AppConfig.splitSymbol);

  SettingsModel prefix = await getSavedSettings();

  if (!AppConfig.searchOggetto) {
    return prefix.prefisso;
  }

  try {
    return "${prefix.prefisso} ${oggetto[AppConfig.oggettoIndex]}";
  } on Exception {
    return prefix.prefisso;
  } on RangeError {
    return prefix.prefisso;
  }
}

String getName(String nomeFile) {
  List<String> name = nomeFile.split(AppConfig.splitSymbol);

  try {
    String nome =
        name[AppConfig.nameIndex].replaceAll(".${AppConfig.fileExtension}", "");
    nome = nome.trim().toUpperCase();
    nome = nome.replaceAll("[^\\p{ASCII}]", "");
    nome = nome.replaceAll("\\p{M}", "");

    logController.text += "\n[INFO] ==> Il nome trovato e: $nome";

    return nome;
  } on Exception {
    logController.text =
        "${logController.text}\n[ERRORE] ==> Il nome trovato e: NULL";
    return "N/D";
  } on RangeError {
    logController.text =
        "${logController.text}\n[ERRORE] ==> Il nome trovato e: NULL (out of range)";
    return "N/D";
  }
}

Future<List<String>> getAllFileInDirectory(String path) async {
  List<String> files = [];

  var dir = Directory(path).listSync();
  logController.text += "\n\n======== FILE TROVATI ========\n";
  for (var file in dir) {
    if (p.basename(file.path).contains(".${AppConfig.fileExtension}")) {
      files.add(p.basename(file.path));
      logController.text +=
          "[INFO] ==> File trovato: ${p.basename(file.path)}\n";
    }
  }
  return files;
}
