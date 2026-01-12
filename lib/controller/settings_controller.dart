import 'package:buste_paga_sender/common/base_credential.dart';
import 'package:buste_paga_sender/model/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/smtp_configuration.dart';

// get the saved settings
Future<SettingsModel> getSavedSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? prefix = prefs.getString('bp-objprefix');

  SettingsModel settings = SettingsModel(
    prefisso: prefix ?? BaseCredential.prefix,
    takeExeDir: false,
  );

  return settings;
}

// get the saved theme
Future<String> getSavedTheme() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String theme = prefs.getString('bp-theme') ?? "system";

  return theme;
}

// get the saved advanced settings
Future<void> getSavedAdvanced() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  AppConfig.splitSymbol =
      prefs.getString('bp-separator') ?? AppConfig.splitSymbol;
  AppConfig.fileExtension =
      prefs.getString('bp-fileExtension') ?? AppConfig.fileExtension;

  AppConfig.oggettoIndex =
      prefs.getInt('bp-objIndex') ?? AppConfig.oggettoIndex;
  AppConfig.nameIndex = prefs.getInt('bp-nameIndex') ?? AppConfig.nameIndex;
  AppConfig.datiCount = prefs.getInt('bp-datiCount') ?? AppConfig.datiCount;

  AppConfig.sendFile = prefs.getBool('bp-sendFile') ?? AppConfig.sendFile;
  AppConfig.searchOggetto =
      prefs.getBool('bp-searchOggetto') ?? AppConfig.searchOggetto;
}

// get the saved mail text
Future<void> getSavedMailText() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String mailtext = prefs.getString('bp-mailtext-html') ?? AppConfig.msg;

  AppConfig.msg = mailtext;
}

// save settings
Future<void> saveSettings(String prefix) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-objprefix', prefix);
  AppConfig.splitSymbol =
      prefs.getString('bp-separator') ?? AppConfig.splitSymbol;
  AppConfig.oggettoIndex =
      prefs.getInt('bp-objIndex') ?? AppConfig.oggettoIndex;
  AppConfig.nameIndex = prefs.getInt('bp-nameIndex') ?? AppConfig.nameIndex;
  AppConfig.datiCount = prefs.getInt('bp-datiCount') ?? AppConfig.datiCount;
}

// save name
Future<void> saveName(int name) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('bp-nameIndex', name - 1);
  AppConfig.splitSymbol =
      prefs.getString('bp-separator') ?? AppConfig.splitSymbol;
  AppConfig.oggettoIndex =
      prefs.getInt('bp-objIndex') ?? AppConfig.oggettoIndex;
  AppConfig.nameIndex = prefs.getInt('bp-nameIndex') ?? AppConfig.nameIndex;
  AppConfig.datiCount = prefs.getInt('bp-datiCount') ?? AppConfig.datiCount;
}

// save dati
Future<void> saveDati(int dati) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('bp-datiCount', dati);
  AppConfig.splitSymbol =
      prefs.getString('bp-separator') ?? AppConfig.splitSymbol;
  AppConfig.oggettoIndex =
      prefs.getInt('bp-objIndex') ?? AppConfig.oggettoIndex;
  AppConfig.nameIndex = prefs.getInt('bp-nameIndex') ?? AppConfig.nameIndex;
  AppConfig.datiCount = prefs.getInt('bp-datiCount') ?? AppConfig.datiCount;
}

// save obj
Future<void> saveObj(int obj) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('bp-objIndex', obj - 1);
  AppConfig.splitSymbol =
      prefs.getString('bp-separator') ?? AppConfig.splitSymbol;
  AppConfig.oggettoIndex =
      prefs.getInt('bp-objIndex') ?? AppConfig.oggettoIndex;
  AppConfig.nameIndex = prefs.getInt('bp-nameIndex') ?? AppConfig.nameIndex;
  AppConfig.datiCount = prefs.getInt('bp-datiCount') ?? AppConfig.datiCount;
}

// save separator
Future<void> saveSeparator(String symbol) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-separator', symbol);
  AppConfig.splitSymbol =
      prefs.getString('bp-separator') ?? AppConfig.splitSymbol;
  AppConfig.oggettoIndex =
      prefs.getInt('bp-objIndex') ?? AppConfig.oggettoIndex;
  AppConfig.nameIndex = prefs.getInt('bp-nameIndex') ?? AppConfig.nameIndex;
  AppConfig.datiCount = prefs.getInt('bp-datiCount') ?? AppConfig.datiCount;
}

// save extension
Future<void> saveExtension(String extension) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-fileExtension', extension);
  await getSavedAdvanced();
}

// save send file
Future<void> saveSendFile(bool file) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('bp-sendFile', file);
}

// save search oggetto
Future<void> saveSearchOggetto(bool obj) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('bp-searchOggetto', obj);
  await getSavedAdvanced();
}

// save theme
Future<void> saveTheme(String theme) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-theme', theme);
}

// save text mail
Future<void> saveMailText(String mailText) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-mailtext-html', mailText.replaceAll("\n", "<br>"));
}

// format the mail body
void formatBody() {
  AppConfig.msg = AppConfig.msg.replaceAll("\n", "<br>");
}

// generate example list
List<String> generateExampleList() {
  return List<String>.generate(AppConfig.datiCount, (index) {
    if (index == (AppConfig.nameIndex)) {
      return "Cognome Nome";
    }
    if (AppConfig.searchOggetto && index == AppConfig.oggettoIndex) {
      return "Oggetto";
    }

    return "AAA";
  });
}
