import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' show ExtensionSet;
import 'package:flutter_markdown/flutter_markdown.dart'
    show MarkdownBody, MarkdownStyleSheet;
import 'package:url_launcher/url_launcher.dart';

import '../style.dart';

class Markdown extends StatelessWidget {
  Markdown(
    this.markdown, {
    Key? key,
    this.baseUrl = '',
  }) : super(key: key);

  final String markdown;
  final String baseUrl;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      extensionSet: ExtensionSet.gitHubWeb,
      styleSheet: MarkdownStyleSheet(
        a: TextStyle(color: blackColor, decoration: TextDecoration.underline),
        h1Padding: EdgeInsets.only(top: 10),
        h2Padding: EdgeInsets.only(top: 10 - 1),
        h3Padding: EdgeInsets.only(top: 10 - 2),
        h4Padding: EdgeInsets.only(top: 10 - 3),
        h5Padding: EdgeInsets.only(top: 10 - 4),
        h6Padding: EdgeInsets.only(top: 10 - 5),
      ),
      data: markdown,
      onTapLink: (_, href, __) {
        if (href == null) return;
        if (!href.startsWith('http')) {
          href = baseUrl + href;
        }
        launch(href);
      },
    );
  }
}
