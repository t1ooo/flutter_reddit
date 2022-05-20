import 'package:flutter/foundation.dart' show ChangeNotifier;

mixin PropertyListener on ChangeNotifier {
  void addPropertyListener<T>(T Function() select, void Function() listener) {
    T value = select();
    addListener(() {
      final newValue = select();
      print([value, newValue]);
      if (value == newValue) {
        return;
      }
      value = newValue;
      listener();
    },);
  }
}
