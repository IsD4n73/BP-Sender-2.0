import 'package:bot_toast/bot_toast.dart';
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:buste_paga_sender/page/home.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'common/base_credential.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getSavedMailText();
  await getSavedAdvanced();

  String theme = await getSavedTheme();
  ThemeMode selectedTheme = ThemeMode.system;

  switch (theme) {
    case "dark":
      selectedTheme = ThemeMode.dark;
      break;
    case "light":
      selectedTheme = ThemeMode.light;
      break;
    default:
      selectedTheme = ThemeMode.system;
  }

  BaseCredential.packageInfo = await PackageInfo.fromPlatform();

  runApp(MyApp(selectedTheme));
}

class MyApp extends StatelessWidget {
  final ThemeMode tema;

  const MyApp(this.tema, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buste Paga Sender',
      themeMode: tema,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff004fff),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff2B6AF7),
          brightness: Brightness.dark,
        ),
      ),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: const HomePage(),
    );
  }
}
