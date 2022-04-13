import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comments.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v2.dart';
import '../notifier/reddir_notifier.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../style/style.dart';
import '../submission/comments.dart';
import '../util/date_time.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';
import '../widget/subscribe_button.dart';
import 'user_about.dart';
import 'user_comment.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

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
                        Text(user.name, textScaleFactor: 2),
                        // Text(user.displayNamePrefixed),
                        Text(user.subreddit.displayNamePrefixed),
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
                    // user.subreddit.userIsSubscriber;
                    // ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
                    // ElevatedButton(onPressed: () {}, child: Text('FOLLOWING')),
                    SubscribeButton(subreddit: user.subreddit, isUserPage: true),
                  ],
                ),
                // Center(child: Text(user.totalKarma.toString())),
                // Center(child: Text(formatDateTime(user.created))),
                SizedBox(height: 20),
                Text(
                    '${user.totalKarma} karma * ${formatDateTime(user.created)}'),
                SizedBox(height: 10),
                 Text(user.subreddit.publicDescription),
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
                // SubmissionTiles(
                //   submissions: [],
                //   onTypeChanged: (type) {
                //     // TODO
                //   },
                //   showTrending: false,
                //   showTypeSelector: false,
                // ),
                SubmissionTiles(
                  showTrending: false,
                  showTypeSelector: false,
                  stream: (context, type) =>
                      context.read<RedditNotifier>().userSubmissions(user.name),
                ),
                UserComments(name: user.name),
                UserAbout(user: user),
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
    //             //           Text('Submissions'),
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
    //             //             SubmissionTiles(),
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
    //                   Text('Submissions'),
    //                   Text('Comments'),
    //                   Text('About'),
    //                 ],
    //               ),
    //             ),
    //             // SizedBox(
    //             //   height: 1000,
    //             //   child: TabBarView(
    //             //     children: [
    //             //       // SubmissionTiles(),
    //             //       Text('1'),
    //             //       Text('2'),
    //             //       Text('3'),
    //             //     ],
    //             //   ),
    //             // ),
    //             Expanded(
    //               child: TabBarView(
    //                 children: [
    //                   // SubmissionTiles(),
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
    //             //       child: Container(child: Text('Submissions')),
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
