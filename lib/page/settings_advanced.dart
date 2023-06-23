import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/smtp_configuration.dart';
import '../controller/settings_controller.dart';

class SettingsAdvanced extends StatefulWidget {
  final bool isVisible;
  const SettingsAdvanced(this.isVisible, {super.key});

  @override
  State<SettingsAdvanced> createState() => _SettingsAdvancedState();
}

class _SettingsAdvancedState extends State<SettingsAdvanced> {
  TextEditingController separatorController = TextEditingController();
  TextEditingController extensionController = TextEditingController();
  TextEditingController objController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController datiController = TextEditingController();
  bool sendFile = true;
  bool searchOggetto = true;

  List<String> listData = ["nome", "oggetto"];

  @override
  void initState() {
    getSavedAdvanced().then((_) {
      setState(() {
        separatorController.text = AppConfig.splitSymbol;
        datiController.text = AppConfig.datiCount.toString();
        objController.text = (AppConfig.oggettoIndex + 1).toString();
        nameController.text = (AppConfig.nameIndex + 1).toString();
        extensionController.text = AppConfig.fileExtension;
        sendFile = AppConfig.sendFile;
        searchOggetto = AppConfig.searchOggetto;

        listData = generateExampleList();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Divider(),
          CheckboxListTile(
            title: const Text("Allega File"),
            subtitle: const Text("Includi il file nella mail"),
            value: sendFile,
            onChanged: (newValue) async {
              await saveSendFile(newValue!);
              setState(() {
                sendFile = newValue;
              });
            },
            activeColor: Colors.blue,
          ),
          const SizedBox(height: 10),
          CheckboxListTile(
            title: const Text("Cerca Oggetto"),
            subtitle: const Text(
                "Cerca nel file anche l'oggetto da inserire dopo il prefisso"),
            value: searchOggetto,
            onChanged: (newValue) async {
              await saveSearchOggetto(newValue!).then((value) {
                setState(() {
                  searchOggetto = newValue;
                  listData = generateExampleList();
                });
              });
            },
            activeColor: Colors.blue,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: extensionController,
            maxLength: 3,
            onChanged: (value) async {
              if (extensionController.text.isNotEmpty) {
                await saveExtension(extensionController.text);
                setState(() {
                  listData = generateExampleList();
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Estensione File',
              prefixText: ".",
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: separatorController,
            maxLength: 1,
            onChanged: (value) async {
              if (separatorController.text.isNotEmpty) {
                await saveSeparator(separatorController.text);
                setState(() {
                  listData = generateExampleList();
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Separatore (** - Mese - Cognome Nome)',
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: datiController,
            maxLength: 1,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Numero Dati',
            ),
            onChanged: (value) async {
              if (datiController.text.isNotEmpty) {
                await saveDati(int.parse(datiController.text));
                setState(() {
                  listData = generateExampleList();
                });
              }
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Oggetto"),
                    TextField(
                      controller: objController,
                      maxLength: 1,
                      enabled: searchOggetto,
                      onChanged: (value) async {
                        if (objController.text.isNotEmpty) {
                          await saveObj(int.parse(objController.text));
                          setState(() {
                            listData = generateExampleList();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Posizione Oggetto',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Nome"),
                    TextField(
                      controller: nameController,
                      maxLength: 1,
                      onChanged: (value) async {
                        if (nameController.text.isNotEmpty) {
                          await saveName(int.parse(nameController.text));
                          setState(() {
                            listData = generateExampleList();
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Posizione Nome',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
              "${listData.join(AppConfig.splitSymbol)}.${AppConfig.fileExtension}"),
        ],
      ),
    );
  }
}
