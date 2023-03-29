import 'package:shared_preferences/shared_preferences.dart';

import '../common/account_model.dart';

// get the saved email and password
Future<AccountModel> getSavedAccount() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? email = prefs.getString('bp-email');
  final String? psw = prefs.getString('bp-password');

  AccountModel settings = AccountModel(
    email: email,
    password: psw,
  );

  return settings;
}

// save account credentials
Future<void> saveAccount(String email, String psw) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('bp-email', email);
  await prefs.setString('bp-password', psw);
}
