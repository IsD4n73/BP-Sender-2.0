import 'package:buste_paga_sender/common/alerts.dart';
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController prefixController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getSavedSettings().then((value) {
      setState(() {
        prefixController.text = value.prefisso;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Impostazioni",
          style: TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 25),
        TextField(
          controller: prefixController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Prefisso Oggetto Email',
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (prefixController.text.isNotEmpty) {
              await saveSettings(prefixController.text);
              showSettingsSaved();
            } else {
              showSettingsError();
            }
          },
          child: const Text("Salva Impostazioni"),
        ),
      ],
    );
  }
}
