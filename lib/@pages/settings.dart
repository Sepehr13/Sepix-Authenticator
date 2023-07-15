// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_local_variable, avoid_single_cascade_in_expression_statements, unused_element, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../@states/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _biometrics = false;
  bool _privacy = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsState settingsState = Provider.of<SettingsState>(context);
    return CupertinoTabView(
      builder: (BuildContext context) => CupertinoPageScaffold(
          backgroundColor:
              CupertinoTheme.of(context).brightness == Brightness.dark
                  ? CupertinoTheme.of(context).scaffoldBackgroundColor
                  : CupertinoColors.systemGroupedBackground,
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                border: Border(bottom: BorderSide.none),
                largeTitle: Text('Settings'),
                backgroundColor:
                    CupertinoTheme.of(context).brightness == Brightness.dark
                        ? CupertinoTheme.of(context).scaffoldBackgroundColor
                        : CupertinoColors.systemGroupedBackground,
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (ctx, index) => CupertinoListSection(
                            header: const Text('Security'),
                            children: <CupertinoListTile>[
                              CupertinoListTile(
                                title: const Text('Use Biometrics'),
                                leading: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: CupertinoColors.activeGreen,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Icon(
                                    CupertinoIcons.lock,
                                    color: CupertinoColors.white,
                                    size: 16,
                                  ),
                                ),
                                trailing: CupertinoSwitch(
                                    value: _biometrics,
                                    onChanged: (_) {
                                      setState(() {
                                        _biometrics = !_biometrics;
                                      });
                                    }),
                              ),
                              CupertinoListTile(
                                title: const Text('Privacy Screen'),
                                leading: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: CupertinoColors.activeOrange,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Icon(
                                    CupertinoIcons.eye,
                                    color: CupertinoColors.white,
                                    size: 16,
                                  ),
                                ),
                                trailing: CupertinoSwitch(
                                    value: _privacy,
                                    onChanged: (_) {
                                      setState(() {
                                        _privacy = !_privacy;
                                      });
                                    }),
                              ),
                            ],
                          ),
                      childCount: 1),
                ),
              ),
            ],
          )),
    );
  }
}
