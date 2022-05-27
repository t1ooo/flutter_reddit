import '../reddit_api/rule.dart';
import 'base_notifier.dart';
import 'collapsible.dart';

class RuleNotifier extends BaseNotifier with Collapsible {
  RuleNotifier(this._rule) {
    setCollapsed(true);
  }

  final Rule _rule;
  Rule get rule => _rule;
}
