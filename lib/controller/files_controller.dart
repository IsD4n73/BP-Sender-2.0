import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:buste_paga_sender/model/settings_model.dart';
import 'package:buste_paga_sender/page/sender.dart';

// get the obj from file name
Future<String> getOggetto(String nomeFile) async {
  List<String> oggetto = nomeFile.split("-");

  SettingsModel prefix = await getSavedSettings();

  try {
    return "${prefix.prefisso} ${oggetto[1]}";
  } on Exception {
    return prefix.prefisso;
  }
}

String getName(String nomeFile) {
  List<String> name = nomeFile.split("-");

  try {
    String nome = name[2].replaceAll(".pdf", "");
    nome = nome.trim().toUpperCase();
    nome = nome.replaceAll("[^\\p{ASCII}]", "");
    nome = nome.replaceAll("\\p{M}", "");

    logController.text += "\n[INFO] ==> Il nome trovato e: $nome";

    return nome;
  } on Exception {
    logController.text =
        "${logController.text}\n[ERRORE] ==> Il nome trovato e: NULL";
    return "NULL";
  }
}

Future<List<String>> getAllFileInDirectory(String path) async {
  List<String> files = [];

  var dir = Directory(path).listSync();

  for (var file in dir) {
    if (p.basename(file.path).contains(".pdf")) {
      files.add(p.basename(file.path));
    }
  }
  return files;
}
