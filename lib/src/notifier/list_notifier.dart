import 'package:flutter/foundation.dart' show ChangeNotifier;

class ListNotifier<T extends ChangeNotifier> extends ChangeNotifier {
  ListNotifier(this._values) {
    for (final value in _values) {
      value.addListener(() {
        notifyListeners();
      });
    }
  }

  UnmodifiableListView<T> get values => UnmodifiableListView(_values);
  
  // ignore: prefer_final_fields
  List<T> _values;
}
