import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../style/style.dart';
import 'submission_tile.dart';

class GSubmissionTiles<T> extends StatelessWidget {
  GSubmissionTiles({
    Key? key,
    required this.type,
    required this.types,
    required this.onTypeChanged,
    required this.submissions,
    this.activeLink = true,
    this.showTypeSelector = true,
  }) : super(key: key);

  final T type;
  final List<T> types;
  final List<SubmissionNotifierQ>? submissions;
  final void Function(T) onTypeChanged;
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
      // shrinkWrap: true,
      children: [
        // Padding(
        //   // width: 100,
        //   padding: const EdgeInsets.only(left: 20),
        //   child: // alignedDropdown: false,
        //       DropdownButton<T>(
        //     // isExpanded: true,
        //     // selectedItemBuilder: (ctx) => [Text(_typeToString(type))],
        //     // hint: Text('123'),
        //     // disabledHint: Text('123'),
        //     // menuMaxHeight: 100,
        //     onTap: () {

        //     },
        //     underline: Container(),
        //     value: type,
        //     onChanged: (v) {
        //       if (v != null) onTypeChanged(v);
        //     },
        //     items: [
        //       for (final type in types)
        //         DropdownMenuItem(
        //           value: type,
        //           child: Text(_typeToString(type) + ' POSTS'),
        //         )
        //     ],
        //   ),
        // ),

        Align(
          alignment: Alignment.centerLeft,
          // width: 100,
          // padding: const EdgeInsets.only(left: 20),
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
                    return RadioList<T>(
                      initialValue: type,
                      onChanged: (t) {
                        onTypeChanged(t);
                        Navigator.pop(context);
                      },
                      titleBuilder: (t) => Text(_typeToString(t)),
                      values: types,
                    );
                    // return Column(
                    // children: [
                    //   for (final type in types)
                    //     RadioListTile<T>(
                    //       controlAffinity: ListTileControlAffinity.trailing,
                    //       value: type,
                    //       secondary: Icon(Icons.check),
                    //       groupValue: type,
                    //       title: Text(_typeToString(type) + ' POSTS'),
                    //       onChanged: (_) {},
                    //     )
                    // ],

                    // title: Text('Material Dialog'),
                    // content: Text('Hey! I am Coflutter!'),
                    // actions: <Widget>[
                    //   TextButton(
                    //       onPressed: () {
                    //         // _dismissDialog();
                    //       },
                    //       child: Text('Close')),
                    //   TextButton(
                    //     onPressed: () {
                    //       print('HelloWorld!');
                    //       // _dismissDialog();
                    //     },
                    //     child: Text('HelloWorld!'),
                    //   )
                    // ],
                    // );
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(_typeToString(type) + ' POSTS'),
                  ),
                  Icon(Icons.expand_more),
                ],
              ),
            ),
          ),
        ),
        // SizedBox(height: 50),
        for (final sub in submissions ?? [])
          ChangeNotifierProvider<SubmissionNotifierQ>.value(
            value: sub,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SubmissionTile(activeLink: activeLink),
            ),
          ),
      ],
    );
  }

  String _typeToString(s) {
    return s.toString().split('.').last.toUpperCase();
  }
}

class RadioList<T> extends StatefulWidget {
  RadioList({
    Key? key,
    required this.initialValue,
    required this.values,
    required this.titleBuilder,
    required this.onChanged,
  }) : super(key: key);

  final T initialValue;
  final List<T> values;
  final Widget Function(T) titleBuilder;
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
        // RadioListTile<T>(
        //   controlAffinity: ListTileControlAffinity.trailing,
        //   selected: value == _value,
        //   // toggleable: true,
        //   value: value,
        //   // secondary: Icon(Icons.check),
        //   groupValue: _value,
        //   title: widget.titleBuilder(value),
        //   onChanged: (v) {
        //     if (v != null) {
        //       widget.onChanged(v);
        //     }
        //   },
        //   // tileColor:Colors.black,
        //   // selectedTileColor: Colors.black,
        // )
      ],
    );
  }
}

// class GSubmissionTiles extends StatelessWidget {
//   GSubmissionTiles({
//     Key? key,
//     // required this.type,
//     // required this.types,
//     required this.submissions,
//     required this.dropdownButton,
//     // required this.onTypeChanged,
//     this.activeLink = true,
//     // this.showTrending = true,
//     this.showTypeSelector = true,
//     // this.showLocationSelector = true,
//   }) : super(key: key);

//   // final T type;
//   // final List<T> types;
//   final List<SubmissionNotifierQ>? submissions;
//   final Widget dropdownButton;
//   // final Function(T) onTypeChanged;
//   final bool activeLink;
//   // final bool showTrending;
//   final bool showTypeSelector;
//   // final bool showLocationSelector;

//   @override
//   Widget build(BuildContext context) {
//     // WidgetsBinding.instance?.addPostFrameCallback((_) {
//     //   onTypeChanged(type);
//     // });
//     if (submissions == null) {
//       return Center(child: CircularProgressIndicator());
//     }

//     return ListView(
//       shrinkWrap: true,
//       children: [
//         // CustomDropdownButton<T>(
//         //   value: type,
//         //   values: types,
//         //   onChanged: onTypeChanged,
//         // ),
//         dropdownButton,
//         SizedBox(height: 50),
//         for (final sub in submissions ?? [])
//           ChangeNotifierProvider<SubmissionNotifierQ>.value(
//             value: sub,
//             child: SubmissionTile(activeLink: activeLink),
//           ),
//       ],
//     );
//   }
// }

class SubmissionTiles extends StatelessWidget {
  SubmissionTiles({
    Key? key,
    this.type = SubType.hot, // TODO: make required
    required this.submissions,
    required this.onTypeChanged,
    this.activeLink = true,
    // this.showTrending = true,
    this.showTypeSelector = true,
    // this.showLocationSelector = true,
  }) : super(key: key);

  final SubType type;
  final List<SubmissionNotifierQ>? submissions;
  final Function(SubType) onTypeChanged;
  final bool activeLink;
  // final bool showTrending;
  final bool showTypeSelector;
  // final bool showLocationSelector;

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
        // Row(
        //   children: [
        //     if (showTypeSelector)
        //       DropdownButton<SubType>(
        //         value: type,
        //         onChanged: (v) {
        //           if (v != null) onTypeChanged(v);
        //         },
        //         items: SubType.values
        //             .map<DropdownMenuItem<SubType>>((SubType type) {
        //           return DropdownMenuItem<SubType>(
        //             value: type,
        //             child: Text(type.toString()),
        //           );
        //         }).toList(),
        //       ),
        //     Spacer(),
        //     Text('...'),
        //   ],
        // ),
        SizedBox(height: 50),
        // ],
        // if (showTrending) ...[
        //   Text('Trending today'),
        //   SizedBox(
        //     height: 200,
        //     child: CustomScroll(
        //       child: ListView(
        //         scrollDirection: Axis.horizontal,
        //         children: <Widget>[
        //           for (int i = 0; i < 10; i++)
        //             Padding(
        //               padding: EdgeInsets.only(left: 10),
        //               child: SizedPlaceholder(width: 200, height: 200 * 3 / 4),
        //             ),
        //         ],
        //       ),
        //     ),
        //   ),
        //   SizedBox(height: 10),
        // ],
        for (final sub in submissions ?? [])
          ChangeNotifierProvider<SubmissionNotifierQ>.value(
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
    // this.showTrending = true,
    this.showTypeSelector = true,
    // this.showLocationSelector = true,
  }) : super(key: key);

  final Sort sort;
  final List<SubmissionNotifierQ>? submissions;
  final Function(Sort) onTypeChanged;
  final bool activeLink;
  // final bool showTrending;
  final bool showTypeSelector;
  // final bool showLocationSelector;

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
        // Row(
        //   children: [
        //     if (showTypeSelector)
        //       DropdownButton<Sort>(
        //         value: sort,
        //         onChanged: (v) {
        //           if (v != null) onTypeChanged(v);
        //         },
        //         items: Sort.values.map<DropdownMenuItem<Sort>>((Sort sort) {
        //           return DropdownMenuItem<Sort>(
        //             value: sort,
        //             child: Text(sort.toString()),
        //           );
        //         }).toList(),
        //       ),
        //     Spacer(),
        //     Text('...'),
        //   ],
        // ),
        SizedBox(height: 50),
        // ],
        // if (showTrending) ...[
        //   Text('Trending today'),
        //   SizedBox(
        //     height: 200,
        //     child: CustomScroll(
        //       child: ListView(
        //         scrollDirection: Axis.horizontal,
        //         children: <Widget>[
        //           for (int i = 0; i < 10; i++)
        //             Padding(
        //               padding: EdgeInsets.only(left: 10),
        //               child: SizedPlaceholder(width: 200, height: 200 * 3 / 4),
        //             ),
        //         ],
        //       ),
        //     ),
        //   ),
        //   SizedBox(height: 10),
        // ],
        for (final sub in submissions ?? [])
          ChangeNotifierProvider<SubmissionNotifierQ>.value(
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
