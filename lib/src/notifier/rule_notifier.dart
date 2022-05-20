import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../reddit_api/rule.dart';
import 'collapse_mixin.dart';

class RuleNotifier with Collapse, ChangeNotifier {
  RuleNotifier(this._rule) {
    setCollapsed(true);
  }

  final Rule _rule;
  Rule get rule => _rule;
}
