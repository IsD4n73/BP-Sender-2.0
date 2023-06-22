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

// get the saved separator
Future<String> getSavedSeparator() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String symbol =
      prefs.getString('bp-separator') ?? AppConfig.splitSymbol;

  AppConfig.splitSymbol = symbol;

  return symbol;
}

// get the saved mail text
Future<void> getSavedMailText() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String mailtext = prefs.getString('bp-mailtext') ?? AppConfig.msg;

  AppConfig.msg = mailtext;

  //return mailtext;
}

// save settings
Future<void> saveSettings(String prefix) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-objprefix', prefix);
}

// save separator
Future<void> saveSeparator(String symbol) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-separator', symbol);
}

// save theme
Future<void> saveTheme(String theme) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-theme', theme);
}

// save text mail
Future<void> saveMailText(String mailText) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-mailtext', mailText.replaceAll("\n", "<br>"));
}
