import 'package:flutter/material.dart';

import '../style/style.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(height: 20),
        TextField(
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
