// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:sepix_authenticator/@pages/home.dart';
import 'package:sepix_authenticator/@pages/settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bolt_horizontal),
              label: 'Passwords',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return HomePage();
            case 1:
              return SettingsPage();
            default:
              return HomePage();
          }
        },
      ),
    );
  }
}
