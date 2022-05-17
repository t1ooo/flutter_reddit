import 'package:flutter/material.dart';

import '../search/search_by_subreddit_screen.dart';
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
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class AppBarBackButton extends StatelessWidget {
  AppBarBackButton({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.maybePop(context);
        },
        icon: SpaceBarIcon(Icons.arrow_back),
      ),
    );
  }
}

class AppBarCloseButton extends StatelessWidget {
  AppBarCloseButton({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.maybePop(context);
        },
        icon: SpaceBarIcon(Icons.close),
      ),
    );
  }
}

class SpaceBar extends StatelessWidget {
  SpaceBar({
    Key? key,
    this.src, // TODO: rename to backgroundImage
    this.backgroundColor,
    this.leading,
    this.title,
    this.trailing,
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
          child: Padding(
            padding: EdgeInsets.only(top: 40, right: 10, bottom: 10),
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
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (query) {
          query = query.trim();
          if (query != '') {
            navigatorPushOrReplace(
              context,
              MaterialPageRoute(
                settings: RouteSettings(name: routeName),
                builder: (_) => subreddit != null
                    ? SearchBySubredditScreen(
                        query: query, subreddit: subreddit!)
                    : SearchScreen(query: query),
              ),
            );
          }
        },
        cursorColor: blackColor,
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
