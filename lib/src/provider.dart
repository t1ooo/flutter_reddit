import 'dart:io';

import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'notifier/reddir_notifier.dart';
import 'reddit_api/reddir_api.dart';

Future<ChangeNotifierProvider<RedditNotifier>> redditNotifierProvider() async {
  const clientId = 'JmK31vyAOebqCsKrwUticg';
  const secret = 'l2b3p-Ldfm_6rs4qvX16bm9W_0XdPw';
  const username = 'graibn';
  const password = '5"u/#sAJh%=aGo^k(2Kh*&A8ft<l9=29';

  final reddit = await draw.Reddit.createScriptInstance(
    clientId: clientId,
    clientSecret: secret,
    userAgent: 'Flutter Client',
    username: username,
    password: password, // Fake
  );

  final anonymousReddit = await draw.Reddit.createReadOnlyInstance(
    clientId: clientId,
    clientSecret: secret,
    userAgent: 'Flutter Client',
  );

  final redditApi = RedditApiImpl(reddit, anonymousReddit);
  // final redditApi = FakeRedditApi(reddit, anonymousReddit);

  final redditNotifier = RedditNotifier(redditApi);
  
  await redditNotifier.loadFrontBest();
  await redditNotifier.loadPopular();
  
  return ChangeNotifierProvider.value(value: redditNotifier);
}

// ChangeNotifierProvider<StoryNotifier> storyProvider() {
//   return ChangeNotifierProvider(
//     create: (BuildContext context) => StoryNotifier(
//       context.read<HackerNewsApi>(),
//     ),
//   );
// }

// ChangeNotifierProvider<UserNotifier> userProvider() {
//   return ChangeNotifierProvider(
//     create: (BuildContext context) => UserNotifier(
//       context.read<HackerNewsApi>(),
//     ),
//   );
// }

// ChangeNotifierProvider<ItemNotifier> itemProvider() {
//   return ChangeNotifierProvider(
//     create: (BuildContext context) => ItemNotifier(
//       context.read<HackerNewsApi>(),
//     ),
//   );
// }

// ChangeNotifierProvider<CommentNotifier> commentProvider() {
//   return ChangeNotifierProvider(
//     create: (BuildContext context) => CommentNotifier(),
//   );
// }
