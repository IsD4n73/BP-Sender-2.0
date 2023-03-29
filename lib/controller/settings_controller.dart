import 'package:buste_paga_sender/model/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// get the saved settings
Future<SettingsModel> getSavedSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? prefix = prefs.getString('bp-objprefix');
  final bool? exeDir = prefs.getBool('bp-takeExeDir');

  SettingsModel settings = SettingsModel(
    prefisso: prefix ?? "BP:",
    takeExeDir: exeDir ?? true,
  );

  return settings;
}

// save settings
Future<void> saveSettings(String prefix, bool takeExeDir) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-objprefix', prefix);
  await prefs.setBool("bp-takeExeDir", takeExeDir);
}
