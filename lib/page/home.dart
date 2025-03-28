import 'package:buste_paga_sender/common/alerts.dart';
import 'package:buste_paga_sender/page/account.dart';
import 'package:buste_paga_sender/page/bulk_sender.dart';
import 'package:buste_paga_sender/page/mail_list.dart';
import 'package:buste_paga_sender/page/sender.dart';
import 'package:buste_paga_sender/page/settings.dart';
import 'package:buste_paga_sender/page/user_guide.dart';
import 'package:flutter/material.dart';
import 'package:python_shell/python_shell.dart';
import 'package:side_navigation/side_navigation.dart';
import '../common/base_credential.dart';
import '../common/python_script.dart';
import 'file_splitter.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> views = const [
    SenderPage(),
    BulkSenderPage(),
    AccountPage(),
    MailListPage(),
    SplitPage(),
    SettingsPage(),
    UserGuidePage(),
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    AlertUtils.checkUpgrade();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            selectedIndex: selectedIndex,
            //expandable: false,
            toggler: const SideBarToggler(
              expandIcon: Icons.keyboard_double_arrow_right,
              shrinkIcon: Icons.keyboard_double_arrow_left,
            ),
            initiallyExpanded: true,
            header: SideNavigationBarHeader(
              image: Image.asset(
                "assets/logo.png",
                width: 100,
                height: 70,
              ),
              title: const Text('3EM'),
              subtitle: const Text('Engineering'),
            ),
            footer: SideNavigationBarFooter(
              label: Text('3em.it - v${BaseCredential.packageInfo.version}'),
            ),
            items: const [
              SideNavigationBarItem(
                icon: Icons.document_scanner,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.alternate_email,
                label: 'Invio a Mail List',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Account',
              ),
              SideNavigationBarItem(
                icon: Icons.email_rounded,
                label: 'Mail List',
              ),
              SideNavigationBarItem(
                icon: Icons.splitscreen,
                label: 'File Split',
              ),
              SideNavigationBarItem(
                icon: Icons.settings,
                label: 'Impostazioni',
              ),
              SideNavigationBarItem(
                icon: Icons.help,
                label: 'Guida Utente',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}
