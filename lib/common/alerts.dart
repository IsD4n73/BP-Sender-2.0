import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

/// [ACCOUNT ALERT] ///
void showAccountError() {
  BotToast.showCustomNotification(
    useSafeArea: true,
    duration: const Duration(seconds: 4),
    toastBuilder: (cancelFunc) {
      return const Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text(
                "Non è possibile salvare l'account, controlla username e password"),
          ],
        ),
      );
    },
  );
}

void showAccountSaved() {
  BotToast.showCustomNotification(
    useSafeArea: true,
    duration: const Duration(seconds: 4),
    toastBuilder: (cancelFunc) {
      return const Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle),
            Text("Account salvato correttamente"),
          ],
        ),
      );
    },
  );
}

/// [SETTINGS ALERT] ///
void showSettingsError() {
  BotToast.showCustomNotification(
    useSafeArea: true,
    duration: const Duration(seconds: 4),
    toastBuilder: (cancelFunc) {
      return const Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text(
              "Non è possibile salvare le impostazioni, riprova",
            ),
          ],
        ),
      );
    },
  );
}

void showSettingsSaved() {
  BotToast.showCustomNotification(
    useSafeArea: true,
    duration: const Duration(seconds: 4),
    toastBuilder: (cancelFunc) {
      return const Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle),
            Text("Impostazioni salvate correttamente"),
          ],
        ),
      );
    },
  );
}

/// [FILE ALERT] ///
void showFileError() {
  BotToast.showCustomNotification(
    useSafeArea: true,
    duration: const Duration(seconds: 4),
    toastBuilder: (cancelFunc) {
      return const Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error),
            Text(
              "Non è possibile salvare il log, riprova",
            ),
          ],
        ),
      );
    },
  );
}

void showFileSaved(String dir) {
  BotToast.showCustomNotification(
    useSafeArea: true,
    duration: const Duration(seconds: 4),
    toastBuilder: (cancelFunc) {
      return Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle),
            Text("File salvato correttamente in $dir"),
          ],
        ),
      );
    },
  );
}
