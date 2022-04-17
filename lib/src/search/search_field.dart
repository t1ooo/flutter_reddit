import 'package:flutter/material.dart';

import '../style/style.dart';
import 'search_screen.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    this.value,
  }) : super(key: key);

  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(height: 20),
        TextFormField(
          initialValue: value,
          onFieldSubmitted: (String? query) {
            final q = (query ?? '').trim();
            if (q != '') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchScreen(query: q),
                ),
              );
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
    );
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
