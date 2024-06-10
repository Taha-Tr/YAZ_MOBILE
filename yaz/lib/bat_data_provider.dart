import 'package:flutter/material.dart';

class BLEbatdataprovider extends ChangeNotifier {
  String? _data;

  String? get data => _data;

  void updateData(String newData) {
    // ignore: unnecessary_null_comparison
    if (newData != null) {
      _data = newData;
    } else {
      _data = "";
    }
    notifyListeners();
  }
}