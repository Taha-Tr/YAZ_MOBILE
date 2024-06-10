import 'package:flutter/material.dart';

class BLErightDataProvider extends ChangeNotifier {
  String? _data;

  String? get data => _data;

  void updateData(String newData) {
    // ignore: unnecessary_null_comparison
    if (newData != null) {
      _data = newData;
    } else {
      _data = _data;
    }
    notifyListeners();
  }
  @override
  notifyListeners();
}