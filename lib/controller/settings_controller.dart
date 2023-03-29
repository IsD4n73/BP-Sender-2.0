import 'package:buste_paga_sender/common/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// get the saved settings
Future<SettingsModel> getSavedSettings() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? prefix = prefs.getString('bp-objprefix');

  SettingsModel settings = SettingsModel(
    prefisso: prefix ?? "BP:",
  );

  return settings;
}

// save settings
Future<void> saveSettings(String prefix) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-objprefix', prefix);
}
