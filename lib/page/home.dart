import 'package:buste_paga_sender/page/account.dart';
import 'package:buste_paga_sender/page/bulk_sender.dart';
import 'package:buste_paga_sender/page/mail_list.dart';
import 'package:buste_paga_sender/page/sender.dart';
import 'package:buste_paga_sender/page/settings.dart';
import 'package:buste_paga_sender/page/user_guide.dart';
import 'package:flutter/material.dart';
import 'package:side_navigation/side_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> views = const [
    SenderPage(),
    BulkSenderPage(),
    AccountPage(),
    MailListPage(),
    SettingsPage(),
    UserGuidePage(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            selectedIndex: selectedIndex,
            expandable: false,
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
            footer: const SideNavigationBarFooter(label: Text('3em.it')),
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.dashboard,
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
