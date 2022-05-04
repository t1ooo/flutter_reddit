import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

ChangeNotifierProvider<T> changeNotifierProviderValue<T extends ChangeNotifier>(
  T value,
  Widget child,
) {
  return ChangeNotifierProvider<T>.value(
    value: value,
    child: child,
  );
}

ChangeNotifierProvider<T>
    changeNotifierProviderContext<T extends ChangeNotifier>(
  BuildContext context,
  Widget child,
) {
  return changeNotifierProviderValue(
    context.read<T>(),
    child,
  );
}
