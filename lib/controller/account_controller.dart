import 'package:buste_paga_sender/common/base_credential.dart';
import 'package:buste_paga_sender/common/smtp_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/account_model.dart';

// get the saved email and password
Future<AccountModel> getSavedAccount() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('bp-email');
  final String? psw = prefs.getString('bp-password');
  final String? user = prefs.getString('bp-user');

  AccountModel settings = AccountModel(
    email: email ?? BaseCredential.email,
    password: psw ?? BaseCredential.password,
    user: user ?? BaseCredential.username,
  );

  return settings;
}

// save account credentials
Future<void> saveAccount(String email, String psw, String user) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-email', email);
  await prefs.setString('bp-password', psw);
  await prefs.setString("bp-user", user);
}

Future<void> saveHostConfig(String host, int port) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-host', host);
  await prefs.setInt('bp-port', port);
}

Future<String> getSavedHost() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String host = prefs.getString('bp-host') ?? AppConfig.baseHost;

  return host;
}

Future<int> getSavedPort() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int port = prefs.getInt('bp-port') ?? AppConfig.basePort;

  return port;
}
