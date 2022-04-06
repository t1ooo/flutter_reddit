import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widget/sized_placeholder.dart';
import 'custom_scroll.dart';
import 'thread_tile.dart';
import 'thread_tiles.dart';

class Popular extends StatelessWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            // DropdownButton(
            //   value: 'HOT POSTS',
            //   items: [
            //     DropdownMenuItem(
            //       onTap: () {},
            //       value: 'HOT POSTS',
            //       child: Text('HOT POSTS'),
            //     ),
            //   ],
            //   onChanged: (_) {},
            // ),
            // Text('HOT POSTS'),
            TextButton(
              child: Text('HOT POSTS'),
              onPressed: () {},
            ),
            TextButton(
              child: Text('GLOBAL'),
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Text('Trending today'),
        // CarouselSlider(
        //   options: CarouselOptions(
        //     height: 100.0,
        //     aspectRatio: 4 / 3,
        //     scrollDirection: Axis.horizontal,
        //     viewportFraction: 1,
        //     onScrolled: (_) {},
        //     onPageChanged: (_, __) {},
        //   ),
        //   items: [1, 2, 3, 4, 5].map((i) {
        //     return Builder(
        //       builder: (BuildContext context) {
        //         return Container(
        //           width: 200,
        //           margin: EdgeInsets.symmetric(horizontal: 5.0),
        //           decoration: BoxDecoration(color: Colors.amber),
        //           child: Text(
        //             'text $i',
        //             style: TextStyle(fontSize: 16.0),
        //           ),
        //         );
        //       },
        //     );
        //   }).toList(),
        // ),
        SizedBox(
          height: 200,
          child: CustomScroll(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (int i = 0; i < 10; i++)
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: SizedPlaceholder(width: 200, height: 200*3/4),
                  ),
              ],
            ),
          ),
        ),

        // ThreadTile(),
        // ThreadTile(),
        // ThreadTile(),
        ThreadTiles(),
      ],
    );
  }
}
