import 'package:flutter/material.dart';

import '../home/thread_tiles.dart';
import '../style/style.dart';
import '../widget/sized_placeholder.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
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
                SizedBox(height: 20),
              ],
            ),
          ),
          Container(
            child: TabBar(
              labelColor: Colors.blue,
              tabs: [
                Text('Posts'),
                Text('Comments'),
                Text('About'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ThreadTiles(),
                ThreadTiles(),
                ThreadTiles(),
              ],
            ),
          ),
        ],
      ),
    );

    // return DefaultTabController(
    //   length: 3,
    //   child: ListView(
    //     children: [
    //       // const CircleAvatar(
    //       //   backgroundImage: AssetImage(''),
    //       //   radius: 100,
    //       // ),
    //       Stack(
    //         children: [
    //           SizedPlaceholder(
    //             height: 400,
    //           ),
    //           Padding(
    //             padding: EdgeInsets.only(left: 20, top: 320),
    //             child: SizedPlaceholder(
    //               width: 100,
    //               height: 100,
    //             ),
    //           ),
    //         ],
    //       ),

    //       SizedBox(height: 100),

    //       Padding(
    //         padding: pagePadding,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               children: [
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text('UserName', textScaleFactor: 2),
    //                     Text('u/username'),
    //                   ],
    //                 ),
    //                 Spacer(),
    //                 Column(
    //                   crossAxisAlignment: CrossAxisAlignment.end,
    //                   children: [
    //                     ElevatedButton(onPressed: () {}, child: Text('CHAT')),
    //                     SizedBox(height: 10),
    //                     ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
    //                     // Padding(
    //                     //   padding: EdgeInsets.only(top:10),
    //                     //   child: ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
    //                     // ),
    //                   ],
    //                 ),

    //                 // Text('UserName', textScaleFactor: 2),
    //                 // Spacer(),
    //                 // ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
    //               ],
    //             ),
    //             SizedBox(height: 50),
    //             Text('5674 karma * 1y'),
    //             SizedBox(height: 10),
    //             Text('description'),
    //             SizedBox(height: 50),

    //             // DefaultTabController(
    //             //   length: 3,
    //             //   child: ListView(
    //             //     shrinkWrap: true,
    //             //     children: [
    //             //       TabBar(
    //             //         labelColor: Colors.black,
    //             //         tabs: [
    //             //           Text('Posts'),
    //             //           Text('Comments'),
    //             //           Text('About'),
    //             //         ],
    //             //       ),
    //             //       SizedBox(
    //             //         height: 500,
    //             //         child: TabBarView(
    //             //           children: [
    //             //             // Padding(
    //             //             //   padding: pagePadding,
    //             //             //   child: Home(),
    //             //             // ),
    //             //             // Padding(
    //             //             //   padding: pagePadding,
    //             //             //   child: Popular(),
    //             //             // ),
    //             //             ThreadTiles(),
    //             //             Text('2'),
    //             //             Text('3'),
    //             //           ],
    //             //         ),
    //             //       ),
    //             //     ],
    //             //   ),
    //             // ),

    //             Container(
    //               child: TabBar(
    //                 labelColor: Colors.black,
    //                 tabs: [
    //                   Text('Posts'),
    //                   Text('Comments'),
    //                   Text('About'),
    //                 ],
    //               ),
    //             ),
    //             // SizedBox(
    //             //   height: 1000,
    //             //   child: TabBarView(
    //             //     children: [
    //             //       // ThreadTiles(),
    //             //       Text('1'),
    //             //       Text('2'),
    //             //       Text('3'),
    //             //     ],
    //             //   ),
    //             // ),
    //             Expanded(
    //               child: TabBarView(
    //                 children: [
    //                   // ThreadTiles(),
    //                   Text('1'),
    //                   Text('2'),
    //                   Text('3'),
    //                 ],
    //               ),
    //             ),

    //             // ButtonBar(
    //             //   alignment: MainAxisAlignment.spaceBetween,
    //             //   children: [
    //             //     InkWell(
    //             //       onTap: () {},
    //             //       child: Container(child: Text('Posts')),
    //             //     ),
    //             //     InkWell(
    //             //       onTap: () {},
    //             //       child: Container(child: Text('Comments')),
    //             //     ),
    //             //     InkWell(
    //             //       onTap: () {},
    //             //       child: Container(child: Text('About')),
    //             //     ),
    //             //   ],
    //             // ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
