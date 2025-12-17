import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:buste_paga_sender/common/urls.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class AlertUtils {
  static void showInfo(String text) {
    BotToast.showCustomNotification(
      enableSlideOff: true,
      onlyOne: true,
      crossPage: false,
      align: Alignment.bottomRight,
      duration: const Duration(seconds: 3),
      toastBuilder: (canc) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(width: 5, color: Colors.blue),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/info-animation.json',
                height: 50,
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Informazione",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSuccess(String text) {
    BotToast.showCustomNotification(
      enableSlideOff: true,
      onlyOne: true,
      crossPage: false,
      align: Alignment.bottomRight,
      duration: const Duration(seconds: 3),
      toastBuilder: (canc) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(width: 5, color: Colors.green),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/ok-animation.json',
                height: 50,
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Successo",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void showError(String text) {
    BotToast.showCustomNotification(
      enableSlideOff: true,
      onlyOne: true,
      crossPage: false,
      align: Alignment.bottomRight,
      duration: const Duration(seconds: 3),
      toastBuilder: (canc) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(width: 5, color: Colors.red),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/error-animation.json',
                height: 50,
                width: 50,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Errore",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static void checkUpgrade() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var response = await http.get(Uri.parse(AppUrls.versionFile));

    if (response.statusCode != 200) {
      return;
    }
    var lastVersion = jsonDecode(response.body)["version"];
    Version lastVersionParsed = Version.parse(lastVersion);
    Version currentVersionParsed = Version.parse(packageInfo.version);
    int compared = lastVersionParsed.compareTo(currentVersionParsed);

    if (compared <= 0) {
      return;
    }

    BotToast.showCustomNotification(
      enableSlideOff: true,
      onlyOne: true,
      crossPage: true,
      align: Alignment.topRight,
      duration: const Duration(minutes: 5),
      toastBuilder: (canc) {
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              left: BorderSide(width: 5, color: Colors.yellow),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Aggiornamento Disponibile!",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "E' disponibile una nuova versione del programma\nPer installare la nuova versione cliccare il pulsante AGGIORNA",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: canc,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text("Ignora"),
                  ),
                  TextButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse(AppUrls.installerFile));
                      canc();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                    ),
                    child: const Text("AGGIORNA"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
