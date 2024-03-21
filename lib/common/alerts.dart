import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class AlertUtils {
  static void showInfo(String text) {
    var cancel = BotToast.showCustomNotification(
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
          child: Column(
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
        );
      },
    );
  }

  static void showSuccess(String text) {
    var cancel = BotToast.showCustomNotification(
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
          child: Column(
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
        );
      },
    );
  }

  static void showError(String text) {
    var cancel = BotToast.showCustomNotification(
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
          child: Column(
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
        );
      },
    );
  }
}
