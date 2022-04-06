import 'package:flutter/material.dart';

import '../home/post_tiles.dart';
import '../style/style.dart';
import '../widget/sized_placeholder.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Stack(
        //   children: [
        //     SizedPlaceholder(
        //       height: 200,
        //     ),
        //     Padding(
        //       padding: EdgeInsets.only(left: 20, top: 150),
        //       child: SizedPlaceholder(
        //         width: 50,
        //         height: 50,
        //       ),
        //     ),
        //   ],
        // ),
        // SizedPlaceholder(
        //   height: 200,
        // ),
        Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedPlaceholder(
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UserName', textScaleFactor: 2),
                      Text('u/username'),
                    ],
                  ),
                  // Spacer(),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     ElevatedButton(onPressed: () {}, child: Text('CHAT')),
                  //     SizedBox(height: 10),
                  //     ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
                  //     // Padding(
                  //     //   padding: EdgeInsets.only(top:10),
                  //     //   child: ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
                  //     // ),
                  //   ],
                  // ),

                  // Text('UserName', textScaleFactor: 2),
                  // Spacer(),
                  // ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
                ],
              ),
              SizedBox(height: 20),
              Row(
                // alignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text('CHAT')),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
                ],
              ),
              SizedBox(height: 20),
              Text('5674 karma * 1y'),
              SizedBox(height: 10),
              Text('description'),
              // SizedBox(height: 20),
              // Text('$type'),
            ],
          ),
        ),
        PostTiles(),
      ],
    );
  }
}
