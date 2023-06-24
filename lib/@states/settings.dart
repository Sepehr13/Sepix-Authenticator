import 'package:flutter/cupertino.dart';
import '../@types/Entity.type.dart';

class SettingsState extends ChangeNotifier {
  List<Entity> _list = [];
  List<Entity> get list => _list;
  set list(List<Entity> list) {
    _list = list;
    notifyListeners();
  }
}
