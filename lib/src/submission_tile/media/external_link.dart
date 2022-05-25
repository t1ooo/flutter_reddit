import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalLink extends StatelessWidget {
  ExternalLink({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launch(url);
      },
      child: Row(children: [
        Flexible(
          child: Text(
            url,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 5),
        Icon(Icons.open_in_new),
      ]),
    );
  }
}
