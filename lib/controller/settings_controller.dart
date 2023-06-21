import 'package:buste_paga_sender/common/base_credential.dart';
import 'package:buste_paga_sender/model/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// save settings
Future<void> saveSettings(String prefix) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-objprefix', prefix);
}
