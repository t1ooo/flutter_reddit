import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/logging.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.dart';
import 'package:provider/provider.dart';

import '../ui_logger.dart';
import '../notifier/submission_notifier.dart';
import '../style.dart';
import '../widget/icon_text.dart';
import '../widget/list.dart';
import 'submission_tile.dart';

class SubmissionTiles<T> extends StatelessWidget {
  const SubmissionTiles({
    Key? key,
    required this.type,
    required this.types,
    required this.load,
    required this.submissions,
    this.showTypeSelector = true,
  }) : super(key: key);

  final T type;
  final List<T> types;
  final List<SubmissionNotifier>? submissions;
  final Future<void> Function(T) load;

  final bool showTypeSelector;

  @override
  Widget build(BuildContext context) {
    return Loader<List<SubmissionNotifier>>(
      load: (_) => load(type),
      data: (_) => submissions,
      onData: (context, submissions) {
        return CustomListView(
          children: [
            _typeSelector(context),
            for (final sub in submissions)
              ChangeNotifierProvider<SubmissionNotifier>.value(
                value: sub,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SubmissionTile(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _typeSelector(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.width / 30),
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: _modal,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconText(
                icon: _typeIcon(type),
                text: Text(_typeToString(type) + ' POSTS'),
              ),
            ),
            Icon(Icons.expand_more),
          ],
        ),
      ),
    );
  }

  Widget _modal(BuildContext context) {
    return CustomListView(
      children: [
        ListTile(
          minLeadingWidth: 0,
          title: Text('SORT POST BY'),
        ),
        Divider(),
        _RadioList<T>(
          initialValue: type,
          onChanged: (t) {
            load(t);
            Navigator.pop(context);
          },
          titleBuilder: (t) => Text(_typeToString(t)),
          iconBuilder: (t) => _typeIcon(t),
          values: types,
        ),
      ],
    );
  }

  String _typeToString(s) {
    return s.toString().split('.').last.toUpperCase();
  }

  Icon _typeIcon(s) {
    switch (s.toString().split('.').last) {
      case 'relevance':
        return Icon(Icons.abc);
      case 'comments':
        return Icon(Icons.abc);
      case 'best':
        return Icon(Icons.rocket_launch);
      case 'hot':
        return Icon(Icons.local_fire_department);
      case 'newest':
        return Icon(Icons.new_releases);
      case 'top':
        return Icon(Icons.keyboard_double_arrow_up);
      case 'rising':
        return Icon(Icons.trending_up);
      case 'controversial':
        return Icon(Icons.flash_on);
      default:
        uiLogger.error('icon not found: $s');
        return Icon(Icons.circle);
    }
  }
}

class _RadioList<T> extends StatefulWidget {
  const _RadioList({
    Key? key,
    required this.initialValue,
    required this.values,
    required this.titleBuilder,
    required this.iconBuilder,
    required this.onChanged,
  }) : super(key: key);

  final T initialValue;
  final List<T> values;
  final Widget Function(T) titleBuilder;
  final Widget Function(T)? iconBuilder;
  final void Function(T) onChanged;

  @override
  State<_RadioList<T>> createState() => _RadioListState();
}

class _RadioListState<T> extends State<_RadioList<T>> {
  late T _value;

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final value in widget.values)
          ListTile(
            minLeadingWidth: 0,
            leading:
                // ignore: prefer_null_aware_method_calls
                widget.iconBuilder != null ? widget.iconBuilder!(value) : null,
            title: widget.titleBuilder(value),
            onTap: () {
              setState(() {
                _value = value;
              });
              widget.onChanged(_value);
            },
            trailing: value == _value
                ? Icon(
                    Icons.check,
                    color: selectedColor,
                  )
                : null,
          )
      ],
    );
  }
}
