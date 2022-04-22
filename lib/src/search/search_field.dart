import 'package:flutter/material.dart';

import '../style/style.dart';
import 'search_screen.dart';

class SearchField extends StatelessWidget {
  SearchField({
    Key? key,
    this.query,
  }) : super(key: key);

  final String? query;
  static final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _controller.text = query ?? '';
    });
    return WillPopScope(
      onWillPop: () async {
        _controller.clear();
        return true;
      },
      child: Column(
        children: [
          // SizedBox(height: 20),
          TextFormField(
            // initialValue: value,
            controller: _controller,
            onFieldSubmitted: (String? query) {
              final q = (query ?? '').trim();
              if (q != '') {
                // _controller.clear();
                // print(ModalRoute.of(context)?.settings.name);
                final route = MaterialPageRoute(
                  settings: RouteSettings(name: 'SearchScreen'),
                  builder: (_) => SearchScreen(query: q),
                );

                /* if (ModalRoute.of(context)?.settings.name ==
                    route.settings.name) {
                  // if (ModalRoute.of(context)?.settings.name == 'SearchScreen') {
                  // if (ModalRoute.of(context) == route) {
                  Navigator.pushReplacement(context, route);
                } else {
                  // Navigator.replaceRouteBelow();
                  Navigator.push(context, route);
                } */
                navigatorPushOrReplace(context, route);
              }
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 50),
        ],
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

class SearchFieldImage extends StatelessWidget {
  const SearchFieldImage({Key? key, required this.src}) : super(key: key);

  final String src;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(src),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: pagePadding,
        child: SearchField(),
      ),
    );
  }
}
