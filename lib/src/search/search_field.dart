import 'package:flutter/material.dart';

import '../style/style.dart';
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

// TODO: split to app bar and search form
// TODO: rename to search bar|app bar
class SearchField extends StatelessWidget {
  SearchField({
    Key? key,
    this.query,
    this.subreddit,
    this.src, // TODO: rename to backgroundImage
    this.backgroundColor,
    this.leading,
    this.trailing,
    this.showSearchForm = true,
  }) : super(key: key);

  final String? query;
  final String? subreddit;
  final String? src;
  final Color? backgroundColor;
  final Widget? leading;
  final Widget? trailing;
  final bool showSearchForm;

  static final _controller = TextEditingController();
  static final routeName = 'SearchField';

  @override
  Widget build(BuildContext context) {
    if (src != null) {
      return Stack(
        children: [
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _searchField(context),
          ),
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
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      backgroundColor!,
                      Color(backgroundColor!.value - 100),
                    ],
                  ),
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _searchField(context),
          ),
        ],
      );
    }

    return _searchField(context);
  }

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
          leading: leading ?? SizedBox(width: 40),
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.zero,
          title: Opacity(
            opacity: showSearchForm ? 1 : 0,
            child: _searchForm(context),
          ),
          trailing: trailing,
        ),
      ),
    );
  }

  Widget _searchForm(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (query) {
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
      cursorColor: blackColor,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        fillColor: Colors.white,
        filled: true,
        hintText: subreddit != null ? '$subreddit' : 'Search',
        border: OutlineInputBorder(),
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
