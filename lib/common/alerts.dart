import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

// email and password incorrect
void showAccountError() {
  BotToast.showCustomNotification(
    useSafeArea: true,
    duration: const Duration(seconds: 4),
    toastBuilder: (cancelFunc) {
      return Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.error),
            Text(
                "Non è possibile salvare l'account, controlla email e password"),
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
      return Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle),
            Text("Account salvato correttamente"),
          ],
        ),
      );
    },
  );
}
