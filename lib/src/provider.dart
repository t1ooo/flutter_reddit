import 'dart:io';

import 'package:draw/draw.dart' as draw;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'notifier/reddir_notifier.dart';
import 'reddit_api/reddir_api.dart';

const clientId = 'JmK31vyAOebqCsKrwUticg';
const secret = 'l2b3p-Ldfm_6rs4qvX16bm9W_0XdPw';
const username = 'graibn';
const password = '5"u/#sAJh%=aGo^k(2Kh*&A8ft<l9=29';

draw.Reddit? reddit;

// Future<ChangeNotifierProvider<RedditNotifier>> redditNotifierProvider() async {
//   reddit = reddit ??
//       await draw.Reddit.createScriptInstance(
//         clientId: clientId,
//         clientSecret: secret,
//         userAgent: 'Flutter Client',
//         username: username,
//         password: password, // Fake
//       );

//   // final anonymousReddit = await draw.Reddit.createReadOnlyInstance(
//   //   clientId: clientId,
//   //   clientSecret: secret,
//   //   userAgent: 'Flutter Client',
//   // );

//   // final redditApi = RedditApiImpl(reddit, anonymousReddit);
//   final redditApi = RedditApiImpl(reddit!);
//   // final redditApi = FakeRedditApi(reddit, anonymousReddit);
//   // final redditApi = FakeRedditApi(reddit!);

//   final redditNotifier = RedditNotifier(redditApi);

//   // await redditNotifier.loadFrontBest();
//   // await redditNotifier.loadPopular();
//   // await redditNotifier.loadUserSubreddits();

//   return ChangeNotifierProvider.value(value: redditNotifier);
// }

Future<Provider<RedditApi>> redditApiProvider() async {
  reddit = reddit ??
      await draw.Reddit.createScriptInstance(
        clientId: clientId,
        clientSecret: secret,
        userAgent: 'Flutter Client',
        username: username,
        password: password, // Fake
      );

  // final anonymousReddit = await draw.Reddit.createReadOnlyInstance(
  //   clientId: clientId,
  //   clientSecret: secret,
  //   userAgent: 'Flutter Client',
  // );

  // final redditApi = RedditApiImpl(reddit, anonymousReddit);
  final redditApi = RedditApiImpl(reddit!);
  // final redditApi = FakeRedditApi(reddit, anonymousReddit);
  // final redditApi = FakeRedditApi(reddit!);

  return Provider.value(value: redditApi);
}

Future<Provider<RedditApi>> fakeRedditApiProvider() async {
  final redditApi = FakeRedditApi();
  return Provider.value(value: redditApi);
}

ChangeNotifierProvider<RedditNotifier> redditNotifierProvider() {
  // final redditApi = FakeRedditApi();
  // final redditNotifier = RedditNotifier(redditApi);
  // return ChangeNotifierProvider.value(value: redditNotifier);
  return ChangeNotifierProvider(
    create: (BuildContext context) => RedditNotifier(
      context.read<RedditApi>(),
    ),
  );
}

ChangeNotifierProvider<SubscriptionNotifier> subscriptionNotifierProvider(
    bool isSubscriber) {
  return ChangeNotifierProvider(
    create: (BuildContext context) => SubscriptionNotifier(
      context.read<RedditApi>(),
      isSubscriber,
    ),
  );
}

// Future<ChangeNotifierProvider<RedditNotifierFront>>
//     redditNotifierFrontProvider() async {
//   reddit = reddit ??
//       await draw.Reddit.createScriptInstance(
//         clientId: clientId,
//         clientSecret: secret,
//         userAgent: 'Flutter Client',
//         username: username,
//         password: password, // Fake
//       );

//   final redditApi = FakeRedditApi(reddit!);

//   final redditNotifier = RedditNotifierFront(redditApi);

//   // await redditNotifier.loadFrontBest();
//   // await redditNotifier.loadPopular();
//   // await redditNotifier.loadUserSubreddits();

//   return ChangeNotifierProvider.value(value: redditNotifier);
// }

ChangeNotifierProvider<SubTypeNotifier> submissionTypeNotifierProvider() {
  return ChangeNotifierProvider(
    create: (BuildContext context) => SubTypeNotifier(),
  );
}

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
