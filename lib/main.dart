import 'package:bot_toast/bot_toast.dart';
import 'package:buste_paga_sender/common/urls.dart';
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:buste_paga_sender/page/home.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
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
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      home: UpgradeAlert(
        upgrader: Upgrader(
          countryCode: "it",
          languageCode: "it",
          appcastConfig: AppcastConfiguration(
            url: AppUrls.appcastUrl,
          ),
          messages: UpgraderMessages(
            code: 'it',
          ),
        ),
        child: const HomePage(),
      ),
    );
  }
}
