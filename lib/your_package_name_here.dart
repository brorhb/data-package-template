library your_package_name_here;

import 'package:your_package_name_here/repository.dart';
import 'package:flutter/material.dart';

class MyChangeNotifier with ChangeNotifier {
  MyChangeNotifier({Duration updateInterval}) {
    _updateInterval = updateInterval;
    _repository = Repository();
  }

  Duration _updateInterval;
  Repository _repository;

  List _data;
  List get data => _data;
  set data(val) {
    _data = val;
    notifyListeners();
  }

  bool _loading;
  bool get loading => _loading;
  set loading(val) {
    _loading = val;
    notifyListeners();
  }

  bool _backgroundRefreshRunning = false;

  void _backgroundRefresh() async {
    _backgroundRefreshRunning = true;
    if (loading != null && data != null) {
      await fetch();
    }
    Future.delayed(_updateInterval ?? Duration(minutes: 5), _backgroundRefresh);
  }

  dynamic getItem({@required id}) {
    return data.firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future fetch({bool refresh = false}) async {
    data = await _repository.fetch(refresh: refresh);
    if (!_backgroundRefreshRunning) _backgroundRefresh();
  }

  Future delete({@required int itemId}) async {
    return await _repository.delete(itemId: itemId);
  }

}
