import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../style/style.dart';
import '../widget/icon_text.dart';
import 'submission_tile.dart';

class GSubmissionTiles<T> extends StatelessWidget {
  GSubmissionTiles({
    Key? key,
    required this.type,
    required this.types,
    required this.load,
    required this.submissions,
    this.activeLink = true,
    this.showTypeSelector = true,
  }) : super(key: key);

  final T type;
  final List<T> types;
  final List<SubmissionNotifier>? submissions;
  final Future<void> Function(T) load;
  final bool activeLink;

  final bool showTypeSelector;

  @override
  Widget build(BuildContext context) {
    return Loader<List<SubmissionNotifier>>(
      load: (_) => load(type),
      data: (_) => submissions,
      onData: (context, submissions) {
        return ListView(
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.centerLeft,

              // TODO: add icon
              child: ButtonTheme(
                height: 200,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 30),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              minLeadingWidth: 0,
                              title: Text('SORT POST BY'),
                            ),
                            Divider(),
                            RadioList<T>(
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
                      },
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
              ),
            ),
            for (final sub in submissions)
              ChangeNotifierProvider<SubmissionNotifier>.value(
                value: sub,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SubmissionTile(
                    activeLink: activeLink,
                  ),
                ),
              ),
          ],
        );
      },
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

class RadioList<T> extends StatefulWidget {
  RadioList({
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
  State<RadioList<T>> createState() => _RadioListState();
}

class _RadioListState<T> extends State<RadioList<T>> {
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

class SubmissionTiles extends StatelessWidget {
  SubmissionTiles({
    Key? key,
    this.type = SubType.hot, // TODO: make required
    required this.submissions,
    required this.onTypeChanged,
    this.activeLink = true,
    this.showTypeSelector = true,
  }) : super(key: key);

  final SubType type;
  final List<SubmissionNotifier>? submissions;
  final Function(SubType) onTypeChanged;
  final bool activeLink;

  final bool showTypeSelector;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      onTypeChanged(type);
    });
    if (submissions == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      shrinkWrap: true,
      children: [
        CustomDropdownButton<SubType>(
          value: type,
          values: SubType.values,
          onChanged: onTypeChanged,
        ),
        SizedBox(height: 50),
        for (final sub in submissions ?? [])
          ChangeNotifierProvider<SubmissionNotifier>.value(
            value: sub,
            child: SubmissionTile(activeLink: activeLink),
          ),
      ],
    );
  }
}

class SearchSubmissionTiles extends StatelessWidget {
  SearchSubmissionTiles({
    Key? key,
    this.sort = Sort.relevance, // TODO: make required
    required this.submissions,
    required this.onTypeChanged,
    this.activeLink = true,
    this.showTypeSelector = true,
  }) : super(key: key);

  final Sort sort;
  final List<SubmissionNotifier>? submissions;
  final Function(Sort) onTypeChanged;
  final bool activeLink;

  final bool showTypeSelector;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      onTypeChanged(sort);
    });
    if (submissions == null) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView(
      shrinkWrap: true,
      children: [
        CustomDropdownButton<Sort>(
          value: sort,
          values: Sort.values,
          onChanged: onTypeChanged,
        ),
        SizedBox(height: 50),
        for (final sub in submissions ?? [])
          ChangeNotifierProvider<SubmissionNotifier>.value(
            value: sub,
            child: SubmissionTile(activeLink: activeLink),
          ),
      ],
    );
  }
}

class CustomDropdownButton<T> extends StatelessWidget {
  CustomDropdownButton({
    Key? key,
    required this.value,
    required this.values,
    required this.onChanged,
  }) : super(key: key);

  T value;
  List<T> values;
  final Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      items: [
        for (final value in values)
          DropdownMenuItem(
            value: value,
            child: Text(value.toString()),
          )
      ],
    );
  }
}
