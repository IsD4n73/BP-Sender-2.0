import 'package:buste_paga_sender/common/alerts.dart';
import 'package:buste_paga_sender/controller/account_controller.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pswController = TextEditingController();
  TextEditingController userController = TextEditingController();
  bool showPsw = false;

  @override
  void initState() {
    super.initState();

    // get saved account psw e email
    getSavedAccount().then((value) {
      setState(() {
        emailController.text = value.email ?? "";
        pswController.text = value.password ?? "";
        userController.text = value.user ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Credenziali Account",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username SMTP',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: pswController,
              obscureText: !showPsw,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showPsw = !showPsw;
                      });
                    },
                    icon: Icon(
                        showPsw ? Icons.visibility : Icons.visibility_off)),
                labelText: 'Password SMTP',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (emailController.text.length > 3 &&
                    emailController.text.contains("@") &&
                    pswController.text.isNotEmpty &&
                    userController.text.isNotEmpty) {
                  await saveAccount(emailController.text, pswController.text,
                      userController.text);
                  AlertUtils.showInfo("Account salvato correttamente");
                } else {
                  AlertUtils.showError(
                      "Errore nel salvare l'account, riprova.");
                }
              },
              child: const Text("Salva Account"),
            ),
          ],
        ),
      ),
    );
  }
}
