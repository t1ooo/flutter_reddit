import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../reddit_api/rule.dart';
import 'collapsible.dart';

class RuleNotifier with Collapsible, ChangeNotifier {
  RuleNotifier(this._rule) {
    setCollapsed(true);
  }

  final Rule _rule;
  Rule get rule => _rule;
}
