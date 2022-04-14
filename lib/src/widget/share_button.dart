import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Share.share('$title $url');
        // shareDesktop('$url', subject:'mail@example.com');
      },
      child: Row(
        children: [
          Icon(Icons.share),
          Text('Share'),
        ],
      ),
    );
  }
}

// Future<void> shareDesktop(
//   String text, {
//   String? subject,
//   Rect? sharePositionOrigin,
// }) async {
//   final queryParameters = {
//     if (subject != null) 'subject': subject,
//     'body': text,
//   };

//   // see https://github.com/dart-lang/sdk/issues/43838#issuecomment-823551891
//   final uri = Uri(
//     scheme: 'mailto',
//     query: queryParameters.entries
//         .map((e) =>
//             '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
//         .join('&'),
//   );

//   await launch(uri.toString());
// }
