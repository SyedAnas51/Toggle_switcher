import 'package:flutter/foundation.dart';

class GCalToggleController extends ChangeNotifier {
  GCalToggleController({int initialIndex = 0}) : _index = initialIndex;

  int _index;

  int get index => _index;

  void jumpTo(int index) {
    if (index == _index) return;
    _index = index;
    notifyListeners();
  }
}