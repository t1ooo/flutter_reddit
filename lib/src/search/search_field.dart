import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../style/style.dart';
import '../subreddit/subreddit_info.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/network_image.dart';
import 'search_screen.dart';

class SearchIconButton extends StatelessWidget {
  SearchIconButton({
    Key? key,
    required this.iconData,
    this.onPressed,
    this.theme,
  }) : super(key: key);

  final IconData iconData;
  final void Function()? onPressed;
  final IconThemeData? theme;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: theme != null
            ? IconTheme(
                data: theme!,
                child: Icon(iconData),
              )
            : Icon(iconData),
      ),
    );
  }
}
class SearchBackButton extends StatelessWidget {
  SearchBackButton({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: IconTheme(
        data: appBarIconTheme,
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  SearchField({
    Key? key,
    this.query,
    this.subreddit,
    this.src, // TODO: rename to backgroundImage
    this.backgroundColor,
    this.leading,
    this.trailing,
  }) : super(key: key);

  final String? query;
  final String? subreddit;
  final String? src;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? trailing;
  static final _controller = TextEditingController();

  static final routeName = 'SearchField';

  @override
  Widget build(BuildContext context) {
    // if (src != null) {
    //   return Container(
    //     height: double.infinity,
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: CachedNetworkImageProvider(
    //           src!,
    //           cacheManager: context.read<CacheManager>(),
    //         ),
    //         onError: (e, _) => log('$e'),
    //         fit: BoxFit.none,
    //       ),
    //     ),
    //     child: _searchField(context),
    //     // child: Padding(
    //     //   padding: pagePadding.copyWith(top: pagePadding.top + topPadding),
    //     //   child: searchField(context),
    //     // ),
    //   );
    // }
    if (src != null) {
      return Stack(
        // clipBehavior: Clip.none,
        // height: double.infinity,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: CachedNetworkImageProvider(
        //       src!,
        //       cacheManager: context.read<CacheManager>(),
        //     ),
        //     onError: (e, _) => log('$e'),
        //     fit: BoxFit.none,
        //   ),
        // ),
        // child: _searchField(context),
        children: [
          // Container(
          //   height: double.infinity,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: CachedNetworkImageProvider(
          //         src!,
          //         cacheManager: context.read<CacheManager>(),
          //       ),
          //       onError: (e, _) => log('$e'),
          //       fit: BoxFit.none,
          //     ),
          //   ),
          // ),

          // CachedNetworkImage(
          //   imageUrl: src!,
          //   cacheManager: context.read<CacheManager>(),
          //   fit: BoxFit.none,
          //   errorWidget: imageErrorBuilder,
          // ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: appBarExpandedHeight,
            child: CustomNetworkImage(src!, onData: (_, image) {
              return Image(
                image: image,
                fit: BoxFit.cover,
                errorBuilder: imageErrorBuilder,
              );
            }),
          ),

          // Positioned(
          //   top: 200,
          //   left: 0,
          //   right: 0,
          //   // height: 300,
          //   child: SubredditInfo(),
          // ),

          // SubredditInfo(),

          Positioned(
            top: 0,
            // bottom: 0,
            left: 0,
            right: 0,
            child: _searchField(context),
          ),
          // _searchField(context)
        ],
      );
    }

    if (backgroundColor != null) {
      return Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: appBarExpandedHeight,
              // child: Container(color: backgroundColor!),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    // end: Alignment(
                    // 0.8, 0.0), // 10% of the width, so there are ten blinds.
                    colors: <Color>[
                      backgroundColor!,
                      Color(backgroundColor!.value - 100),
                    ], // red to yellow
                    // tileMode: TileMode
                    // .repeated, // repeats the gradient over the canvas
                  ),
                ),
              )),

          Positioned(
            top: 0,
            // bottom: 0,
            left: 0,
            right: 0,
            child: _searchField(context),
          ),
          // _searchField(context)
        ],
      );
    }

    return _searchField(context);
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

  Widget _searchField(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller.text = query ?? '';
    });
    return WillPopScope(
      onWillPop: () async {
        _controller.clear();
        return true;
      },
      child: Padding(
        padding: EdgeInsets.only(top: 40, right: 10, bottom: 10),
        child: ListTile(
          // leading: IconButton(
          //   onPressed: () {
          //     Scaffold.of(context).openEndDrawer();
          //   },
          //   icon: Icon(Icons.account_circle),
          // ),
          leading: leading ?? SizedBox(width: 40),
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.zero,
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
              hintText: subreddit != null ? '$subreddit' : 'Search',
              border: OutlineInputBorder(),
            ),
          ),
          trailing: trailing,
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

// class SearchFieldV2 extends StatelessWidget {
//   SearchFieldV2({
//     Key? key,
//     this.query,
//     this.subreddit,
//     this.src,
//     this.leading,
//     this.trailing,
//   }) : super(key: key);

//   final String? query;
//   final String? subreddit;
//   final String? src;
//   final Widget? leading;
//   final Widget? trailing;
//   static final _controller = TextEditingController();

//   static final routeName = 'SearchField';

//   @override
//   Widget build(BuildContext context) {
//     // if (src != null) {
//     //   return Container(
//     //     height: double.infinity,
//     //     decoration: BoxDecoration(
//     //       image: DecorationImage(
//     //         image: CachedNetworkImageProvider(
//     //           src!,
//     //           cacheManager: context.read<CacheManager>(),
//     //         ),
//     //         onError: (e, _) => log('$e'),
//     //         fit: BoxFit.none,
//     //       ),
//     //     ),
//     //     child: _searchField(context),
//     //   );
//     // }
//     return _searchField(context);
//   }

//   Widget _searchField(BuildContext context) {
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       _controller.text = query ?? '';
//     });
//     return WillPopScope(
//       onWillPop: () async {
//         _controller.clear();
//         return true;
//       },
//       child: FlexibleSpaceBar(
//         collapseMode: CollapseMode.parallax,
//         expandedTitleScale: 1,
//         centerTitle: false,
//         // titlePadding: EdgeInsets.only(top: 0, right: 10, bottom: 200),
//         titlePadding: EdgeInsets.zero,
//         stretchModes: [StretchMode.blurBackground],
//         background: src == null
//             ? null
//             : CachedNetworkImage(
//                 imageUrl: src!,
//                 cacheManager: context.read<CacheManager>(),
//                 fit: BoxFit.cover,
//               ),
//         title: Padding(
//           padding: EdgeInsets.only(top: 40, right: 10, bottom: 10),
//           // padding: EdgeInsets.zero,
//           child: ListTile(
//             leading: leading ?? SizedBox(width: 40),
//             minLeadingWidth: 0,
//             contentPadding: EdgeInsets.zero,
//             title: TextFormField(
//               controller: _controller,
//               onFieldSubmitted: (query) {
//                 query = query.trim();
//                 if (query != '') {
//                   navigatorPushOrReplace(
//                     context,
//                     MaterialPageRoute(
//                       settings: RouteSettings(name: routeName),
//                       builder: (_) => SearchScreen(query: query),
//                     ),
//                   );
//                 }
//               },
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 fillColor: Colors.white,
//                 filled: true,
//                 hintText: subreddit != null ? '$subreddit' : 'Search',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             trailing: trailing,
//           ),
//         ),
//       ),
//     );
//   }
// }

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
