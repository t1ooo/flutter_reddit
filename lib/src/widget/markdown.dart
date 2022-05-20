import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart'
    show MarkdownBody, MarkdownStyleSheet;
import 'package:url_launcher/url_launcher.dart';

import '../style/style.dart';

class Markdown extends StatelessWidget {
  Markdown(
    this.markdown, {
    Key? key,
  }) : super(key: key);

  final String markdown;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      styleSheet: MarkdownStyleSheet(
        a: TextStyle(color: blackColor, decoration: TextDecoration.underline),
        h1Padding: EdgeInsets.only(top:10),
        h2Padding: EdgeInsets.only(top:10-1),
        h3Padding: EdgeInsets.only(top:10-2),
        h4Padding: EdgeInsets.only(top:10-3),
        h5Padding: EdgeInsets.only(top:10-4),
        h6Padding: EdgeInsets.only(top:10-5),
      ),
      data: markdown,
      onTapLink: (_, href, __) {
        if (href != null) launch(href);
      },
    );
  }
}
