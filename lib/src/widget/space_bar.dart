import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../search/search_screen.dart';
import '../style/style.dart';
import 'network_image.dart';

class SpaceBarIcon extends StatelessWidget {
  SpaceBarIcon(
    this.icon, {
    Key? key,
  }) : super(key: key);

  final IconData icon;

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: IconTheme(
          data: appBarIconThemeDark,
          child: Icon(icon),
        ),
        decoration: ShapeDecoration(
          shadows: [
            BoxShadow(
              color: Colors.white54,
              blurRadius: 15,
              spreadRadius: 15,
            )
          ],
          // shape: CircleBorder(side: BorderSide()),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

// class SpaceBarIconButton extends StatelessWidget {
//   SpaceBarIconButton({
//     Key? key,
//     required this.icon,
//     this.onPressed,
//   }) : super(key: key);

//   final Icon icon;
//   final void Function()? onPressed;

//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: IconButton(
//         padding: EdgeInsets.zero,
//         onPressed: () {
//           Navigator.maybePop(context);
//         },
//         // icon: IconTheme(
//         icon: Container(
//           child: IconTheme(
//             data: appBarIconThemeDark,
//             child: icon,
//           ),
//           decoration: ShapeDecoration(
//             // color: Colors.white,
//             shadows: [
//               BoxShadow(
//                 color: Colors.white54,
//                 blurRadius: 15,
//                 spreadRadius: 15,
//               )
//             ],
//             // shape: CircleBorder(side: BorderSide()),
//             shape: CircleBorder(),
//           ),
//         ),
//       ),
//     );
//   }
// }

class SearchBackButton extends StatelessWidget {
  SearchBackButton({
    Key? key,
    // this.theme = appBarIconThemeDark,
  }) : super(key: key);

  // SearchBackButton.black({
  //   Key? key,
  //   this.theme = appBarIconThemeDark,
  // });

  // final IconThemeData theme;

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.maybePop(context);
        },
        // icon: IconTheme(
        //   data: theme,
        //   child: Icon(Icons.arrow_back),
        // ),
        icon: SpaceBarIcon(Icons.arrow_back),

        // icon: Stack(
        //   children: <Widget>[
        //     Positioned(
        //       // left: 1.0,
        //       top: 0.0,
        //       child: Icon(Icons.arrow_back, color: Colors.black54, size:35),
        //     ),
        //     Positioned(
        //       // left: 1.0,
        //       top: 2.0,
        //       left: 2.0,
        //       child: Icon(Icons.arrow_back, color: Colors.white, size:28),
        //     ),
        //     // Icon(Icons.arrow_back, color: Colors.white, size:28),
        //   ],
        // ),
      ),
    );
    // return SearchIconButton(
    //   onPressed: () {
    //     Navigator.of(context).pop(); // does not work
    //   },
    //   iconData: Icons.arrow_back,
    //   theme: appBarIconTheme,
    // );
  }
}

// class PrimarySliverAppBar extends StatelessWidget {
//   PrimarySliverAppBar({
//     Key? key,
//     required this.awardIcons,
//     required this.totalAwardsReceived,
//   }) : super(key: key);

//   final List<String> awardIcons;
//   final int totalAwardsReceived;

//   @override
//   Widget build(BuildContext context) {
//     return SliverAppBar(
//       // stretch: true,
//       pinned: true,
//       // snap: true,
//       primary: true,
//       // leading: Icon(Icons.back_hand),
//       automaticallyImplyLeading: false,
//       collapsedHeight: 120,
//       expandedHeight: appBarExpandedHeight,

//       flexibleSpace: flexibleSpace,
//     );
//   }
// }

class SpaceBar extends StatelessWidget {
  SpaceBar({
    Key? key,
    this.src, // TODO: rename to backgroundImage
    this.backgroundColor,
    this.leading,
    this.title,
    this.trailing,
    // this.showSearchForm = true,
  }) : super(key: key);

  final String? src;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final maxFlex = 10;
    final titleFlex =
        maxFlex - (leading != null ? 1 : 0) - (trailing != null ? 1 : 0);

    return Stack(
      children: [
        if (src != null)
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
          )
        else if (backgroundColor != null)
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: appBarExpandedHeight,
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
                  ),
                ),
              )),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.only(top: 40, right: 10, bottom: 10),
            // child: Container(height: 80, child: title),
            // child: ListTile(
            //   leading: leading ?? SizedBox(width: 40),
            //   minLeadingWidth: 0,
            //   contentPadding: EdgeInsets.zero,
            //   title: Container(height: 80, child: title),
            //   trailing: trailing,
            // ),
            child: Row(
              children: [
                if (leading != null)
                  Expanded(
                    flex: 1,
                    child: leading!,
                  ),
                Expanded(
                  flex: titleFlex,
                  child: Container(height: 60, child: title),
                ),
                if (trailing != null)
                  Expanded(
                    flex: 1,
                    child: trailing!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SearchForm extends StatelessWidget {
  const SearchForm({
    Key? key,
    this.query,
    this.subreddit,
  }) : super(key: key);

  final String? query;
  final String? subreddit;
  static final _controller = TextEditingController();
  static final routeName = 'SearchForm';

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller.text = query ?? '';
    });
    return WillPopScope(
      onWillPop: () async {
        print('pop');
        _controller.clear();
        return true;
      },
      child: TextFormField(
        controller: _controller,
        textInputAction: TextInputAction.search,
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     // settings: RouteSettings(name: routeName),
            //     builder: (_) => SearchScreen(query: query),
            //   ),
            // );
          }
        },
        cursorColor: black,
        decoration: InputDecoration(
          prefixIcon: IconTheme(data: formIconTheme, child: Icon(Icons.search)),
          suffixIcon: IconButton(
            onPressed: _controller.clear,
            icon: IconTheme(data: formIconTheme, child: Icon(Icons.cancel)),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: subreddit != null ? '$subreddit' : 'Search',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          // focusColor: black,
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
