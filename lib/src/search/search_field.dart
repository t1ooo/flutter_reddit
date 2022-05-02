import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import 'search_screen.dart';

class SearchField extends StatelessWidget {
  SearchField({
    Key? key,
    this.query,
    this.subreddit,
    this.src,
  }) : super(key: key);

  final String? query;
  final String? subreddit;
  final String? src;
  static final _controller = TextEditingController();

  static final routeName = 'SearchField';

  @override
  Widget build(BuildContext context) {
    if (src != null) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              src!,
              cacheManager: context.read<CacheManager>(),
            ),
            onError: (e, _) => log('$e'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: pagePadding.copyWith(top: pagePadding.top + topPadding),
          child: searchField(context),
        ),
      );
    }
    return searchField(context);
  }

  // Widget searchField(BuildContext context) {
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     _controller.text = query ?? '';
  //   });
  //   return WillPopScope(
  //     onWillPop: () async {
  //       _controller.clear();
  //       return true;
  //     },
  //     child: Column(
  //       children: [
  //         TextFormField(
  //           controller: _controller,
  //           onFieldSubmitted: (query) {
  //             query = query.trim();
  //             if (query != '') {
  //               navigatorPushOrReplace(
  //                 context,
  //                 MaterialPageRoute(
  //                   settings: RouteSettings(name: routeName),
  //                   builder: (_) => SearchScreen(query: query),
  //                 ),
  //               );
  //             }
  //           },
  //           decoration: InputDecoration(
  //             // icon: Icon(Icons.account_circle, size: 50),
  //             // label: IconButton(onPressed: () {
  //               // Scaffold.of(context).openDrawer();
  //             // }, icon: Icon(Icons.account_circle, size: 50),),
  //             fillColor: Colors.white,
  //             filled: true,
  //             hintText: subreddit != null ? '$subreddit: Search' : 'Search',
  //             border: OutlineInputBorder(),
  //           ),
  //         ),
  //         SizedBox(height: 50),
  //       ],
  //     ),
  //   );
  // }

  Widget searchField(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller.text = query ?? '';
    });
    return WillPopScope(
      onWillPop: () async {
        _controller.clear();
        return true;
      },
      child: ListTile(
        // leading: IconButton(
        //   onPressed: () {
        //     Scaffold.of(context).openEndDrawer();
        //   },
        //   icon: Icon(Icons.account_circle),
        // ),
        leading: SizedBox(width: 20),
        minLeadingWidth: 0,
        title: TextFormField(
          controller: _controller,
          onFieldSubmitted: (query) {
            query = query.trim();
            if (query != '') {
              navigatorPushOrReplace(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(name: routeName),
                  builder: (_) => SearchScreen(query: query),
                ),
              );
            }
          },
          decoration: InputDecoration(
            // icon: Icon(Icons.account_circle, size: 50),
            // label: IconButton(onPressed: () {
            // Scaffold.of(context).openDrawer();
            // }, icon: Icon(Icons.account_circle, size: 50),),
            prefixIcon: Icon(Icons.search),
            fillColor: Colors.white,
            filled: true,
            hintText: subreddit != null ? '$subreddit: Search' : 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

void navigatorPushOrReplace(context, MaterialPageRoute route) {
  final name = route.settings.name;
  if (name == null || name == '') {
    throw Exception('route name must not be empty');
  }
  if (ModalRoute.of(context)?.settings.name == name) {
    Navigator.pushReplacement(context, route);
  } else {
    Navigator.push(context, route);
  }
}

// class SearchFieldImage extends StatelessWidget {
//   const SearchFieldImage({
//     Key? key,
//     required this.src,
//   }) : super(key: key);

//   final String src;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage(src),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Padding(
//         padding: pagePadding,
//         child: SearchField(),
//       ),
//     );
//   }
// }
