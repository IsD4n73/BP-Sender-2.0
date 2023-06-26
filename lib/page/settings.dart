import 'package:buste_paga_sender/common/alerts.dart';
import 'package:buste_paga_sender/common/smtp_configuration.dart';
import 'package:buste_paga_sender/controller/settings_controller.dart';
import 'package:buste_paga_sender/page/settings_advanced.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController prefixController = TextEditingController();
  TextEditingController msgController = TextEditingController();

  String selectedTheme = "system";
  bool advanceSettingsVisible = false;

  @override
  void initState() {
    super.initState();

    getSavedTheme().then((value) {
      setState(() {
        selectedTheme = value;
      });
    });

    getSavedSettings().then((value) {
      setState(() {
        prefixController.text = value.prefisso;
      });
    });

    getSavedMailText().then((_) {
      setState(() {
        msgController.text = AppConfig.msg.replaceAll("<br>", "\n");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Tema Software: "),
                DropdownButton(
                  value: selectedTheme,
                  items: const [
                    DropdownMenuItem(
                      value: "light",
                      child: Text("Light"),
                    ),
                    DropdownMenuItem(
                      value: "dark",
                      child: Text("Dark"),
                    ),
                    DropdownMenuItem(
                      value: "system",
                      child: Text("Sistema"),
                    ),
                  ],
                  hint: const Text("Seleziona Tema"),
                  onChanged: (value) async {
                    await saveTheme(value!);

                    setState(() {
                      selectedTheme = value;
                    });
                    showThemeAlert();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: msgController,
              maxLines: '\n'.allMatches(msgController.text).length + 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Corpo Email (HTML)',
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text("Mostra Impostazioni Avanzate"),
              value: advanceSettingsVisible,
              onChanged: (newValue) {
                setState(() {
                  advanceSettingsVisible = newValue!;
                });
              },
              activeColor: Colors.blue,
            ),
            SettingsAdvanced(advanceSettingsVisible),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveTheme(selectedTheme);

                if (msgController.text.isNotEmpty) {
                  await saveMailText(msgController.text);
                }

                if (prefixController.text.isNotEmpty) {
                  await saveSettings(prefixController.text);
                  showSettingsSaved();
                } else {
                  showSettingsError();
                }
              },
              child: const Text("Salva Impostazioni"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
