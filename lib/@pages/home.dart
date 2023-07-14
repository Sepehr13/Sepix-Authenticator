// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_local_variable, avoid_single_cascade_in_expression_statements, unused_element, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/transformers.dart';
import '../@components/delete_action_sheet.component.dart';
import '../@components/insert_action_sheet.component.dart';
import '../@components/otp_card.component.dart';
import '../@components/otp_empty.component.dart';
import '../@components/otp_shimmer.component.dart';
import '../@states/settings.dart';
import '../@types/Entity.type.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();
  TextEditingController _searchTextController = TextEditingController(text: '');
  late StreamSubscription<String> _searchStream;
  late Timer _periodicRefreshRef;
  int _dangerTime = 8;
  bool _isTyping = false;
  bool _showFilteredList = false;
  List<Entity> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _fetchList();
    _periodicRefresh();
    _searchStream =
        _searchSubject.debounceTime(Duration(seconds: 1)).listen((text) {
      if (_searchTextController.text.trim().isNotEmpty) {
        setState(() {
          _isTyping = false;
          _showFilteredList = true;
          _filteredList = Provider.of<SettingsState>(context, listen: false)
              .list
              .where((e) =>
                  "${e.issuer} (${e.title})".toLowerCase().contains(text))
              .toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchStream.cancel();
    _periodicRefreshRef.cancel();
    super.dispose();
  }

  void _showActionSheet(BuildContext ctasx) {
    showCupertinoModalPopup(
      context: ctasx,
      builder: (BuildContext ctx) => InsertActionSheet(onNewEntity: (entity) {
        _addNewEntity(entity);
        _fetchList();
      }),
    );
  }

  void _showDeleteActionSheet(BuildContext ctasx, Entity entity) {
    showCupertinoModalPopup(
      context: ctasx,
      builder: (BuildContext ctx) => DeleteActionSheet(
          entity: entity,
          onRefresh: () {
            _fetchList();
          }),
    );
  }

  Future<bool> _addNewEntity(Entity entity) async {
    Completer<bool> completer = Completer<bool>();
    Box<Entity> box;
    if (Hive.isBoxOpen('entities')) {
      box = Hive.box<Entity>('entities');
    } else {
      box = await Hive.openBox<Entity>('entities');
    }
    var id = await box.add(entity);
    if (id >= 0) {
      EasyLoading.showSuccess('Entry Added Successfully!');
      completer.complete(true);
    } else {
      completer.complete(false);
    }
    return completer.future;
  }

  void _fetchList() async {
    Box<Entity> box = await Hive.openBox('entities');
    Provider.of<SettingsState>(context, listen: false).list =
        box.values.toList();
    setState(() {
      _isLoading = false;
    });
  }

  void _periodicRefresh() {
    _periodicRefreshRef = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  get otpList {
    if (_showFilteredList) {
      return _filteredList;
    } else {
      return Provider.of<SettingsState>(context).list;
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsState settingsState = Provider.of<SettingsState>(context);
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: CupertinoPageScaffold(
          backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                border: Border(bottom: BorderSide.none),
                largeTitle: Text('Authenticator'),
                backgroundColor:
                    CupertinoTheme.of(context).scaffoldBackgroundColor,
                trailing: GestureDetector(
                  onTap: () {
                    _showActionSheet(context);
                  },
                  child: Icon(
                    CupertinoIcons.add,
                  ),
                ),
              ),
              SliverSafeArea(
                top: false,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (ctx, index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: CupertinoTextField(
                              controller: _searchTextController,
                              onChanged: (v) {
                                if (v.trim().isEmpty) {
                                  setState(() {
                                    _isTyping = false;
                                    _showFilteredList = false;
                                    _filteredList = [];
                                  });
                                } else {
                                  setState(() {
                                    _isTyping = true;
                                  });
                                  _searchSubject.add(v);
                                }
                              },
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              placeholder: 'Search',
                              textAlign: TextAlign.left,
                              prefix: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(CupertinoIcons.search,
                                    // color: CupertinoColors.grey,
                                    size: 20),
                              ),
                              suffix: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: _isTyping
                                    ? CupertinoActivityIndicator()
                                    : _searchTextController.text
                                            .trim()
                                            .isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _searchTextController.text = '';
                                                _isTyping = false;
                                                _showFilteredList = false;
                                                _filteredList = [];
                                              });
                                            },
                                            child: Icon(CupertinoIcons.clear))
                                        : Container(),
                              ),
                            ),
                          ),
                      childCount: 1),
                ),
              ),
              (settingsState.list.isEmpty && _isLoading)
                  ? OTPShimmer()
                  : (otpList.isNotEmpty && !_isLoading)
                      ? SliverSafeArea(
                          top: false,
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (context, index) => OTPCard(
                                      entity: otpList[index],
                                      dangerTime: _dangerTime,
                                      onLongPress: (entity) {
                                        _showDeleteActionSheet(context, entity);
                                      },
                                      onRefresh: _fetchList,
                                    ),
                                childCount: otpList.length),
                          ),
                        )
                      : OTPEmpty()
            ],
          )),
    );
  }
}
