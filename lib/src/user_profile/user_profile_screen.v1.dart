import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../home/submission_tile.dart';
import '../notifier/reddir_notifier.dart';
import '../reddit_api/user.dart';
import '../style/style.dart';
import '../widget/custom_future_builder.dart';
import '../widget/sized_placeholder.dart';
import 'user_profile.v1.dart';

// TODO: rename to UserProfileScreen loader
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    Key? key,
    required this.name,
    this.isCurrentUser = false,
  }) : super(key: key);

  final String name;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    print('User Profile');
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<UserNotifier>().name = name;
      context.read<UserSubmissionsNotifier>().name = name;
      context.read<UserCommentsNotifier>().name = name;
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      // body: UserProfile(name: name),
      body: CustomFutureBuilder(
        // future: context.read<RedditNotifier>().user(name),
        future: context.read<UserNotifier>().user(),
        onData: (BuildContext context, User user) {
          // WidgetsBinding.instance?.addPostFrameCallback((_) {
          //   context.read<UserSubmissionsNotifier>().name = name;
          //   context.read<UserCommentsNotifier>().name = name;
          // });
          return UserProfile(user: user, isCurrentUser: isCurrentUser);
        },
      ),
    );
  }
}

// TODO: rename to UserProfileScreen
class UserProfileScreenV2 extends StatelessWidget {
  const UserProfileScreenV2({
    Key? key,
    required this.user,
    this.isCurrentUser = false,
  }) : super(key: key);

  final User user;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      // body: UserProfile(name: name),
      body: UserProfile(user: user, isCurrentUser: isCurrentUser),
    );
  }
}

// class UserProfileScreen extends StatelessWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Submission'),
//       ),
//       body: UserProfile(),
//     );
//   }
// }

// class UserProfileScreen extends StatelessWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 2,
//         child: CustomScrollView(
//           slivers: [
//             // const SliverAppBar(
//             //   title: Text('title'),
//             //   floating: false,
//             //   flexibleSpace: Header(),
//             //   expandedHeight: 500,
//             // ),
//             SliverList(
//               delegate: SliverChildListDelegate(
//                 [
//                   // const CircleAvatar(
//                   //   backgroundImage: AssetImage(''),
//                   //   radius: 100,
//                   // ),
//                   Stack(
//                     children: [
//                       SizedPlaceholder(
//                         height: 400,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 20, top: 320),
//                         child: SizedPlaceholder(
//                           width: 100,
//                           height: 100,
//                         ),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 100),

//                   Padding(
//                     padding: pagePadding,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('UserName', textScaleFactor: 2),
//                                 Text('u/username'),
//                               ],
//                             ),
//                             Spacer(),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 ElevatedButton(
//                                     onPressed: () {}, child: Text('CHAT')),
//                                 SizedBox(height: 10),
//                                 ElevatedButton(
//                                     onPressed: () {}, child: Text('FOLLOW')),
//                                 // Padding(
//                                 //   padding: EdgeInsets.only(top:10),
//                                 //   child: ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
//                                 // ),
//                               ],
//                             ),

//                             // Text('UserName', textScaleFactor: 2),
//                             // Spacer(),
//                             // ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
//                           ],
//                         ),
//                         SizedBox(height: 50),
//                         Text('5674 karma • 1y'),
//                         SizedBox(height: 10),
//                         Text('description'),
//                         SizedBox(height: 50),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SliverGrid.count(
//               childAspectRatio: 10.0,
//               crossAxisCount: 1,
//               children: [
//                 TabBar(
//                   labelColor: Colors.black,
//                   tabs: [
//                     Text('Submissions'),
//                     Text('Comments'),
//                   ],
//                 ),
//               ],
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate(
//                 [
//                   // SingleChildScrollView(
//                   //     child: Container(
//                   //   child: TabBarView(
//                   //     children: [
//                   //       SubmissionTiles(),
//                   //       SubmissionTiles(),
//                   //     ],
//                   //   ),
//                   // )),

//                   // SubmissionTile(),
//                   // SubmissionTile(),
//                   // SubmissionTile(),
//                   // SubmissionTile(),

//                   // SizedBox(
//                   //   height: 10000,
//                   //   child: TabBarView(
//                   //     children: [
//                   //       // SingleChildScrollView(child: SubmissionTiles()),
//                   //       // SingleChildScrollView(child: SubmissionTiles()),
//                   //       SubmissionTiles(),
//                   //       SubmissionTiles(),
//                   //     ],
//                   //   ),
//                   // ),

//                   TabBarView(
//                       children: [
//                         // SingleChildScrollView(child: SubmissionTiles()),
//                         // SingleChildScrollView(child: SubmissionTiles()),
//                         Expanded(child:SubmissionTiles()),
//                         Expanded(child:SubmissionTiles()),
//                         // SubmissionTiles(),
//                       ],
//                     ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Header extends StatelessWidget {
//   const Header({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // const CircleAvatar(
//         //   backgroundImage: AssetImage(''),
//         //   radius: 100,
//         // ),
//         Stack(
//           children: [
//             SizedPlaceholder(
//               height: 400,
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 20, top: 320),
//               child: SizedPlaceholder(
//                 width: 100,
//                 height: 100,
//               ),
//             ),
//           ],
//         ),

//         SizedBox(height: 100),

//         Padding(
//           padding: pagePadding,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('UserName', textScaleFactor: 2),
//                       Text('u/username'),
//                     ],
//                   ),
//                   Spacer(),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       ElevatedButton(onPressed: () {}, child: Text('CHAT')),
//                       SizedBox(height: 10),
//                       ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
//                       // Padding(
//                       //   padding: EdgeInsets.only(top:10),
//                       //   child: ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
//                       // ),
//                     ],
//                   ),

//                   // Text('UserName', textScaleFactor: 2),
//                   // Spacer(),
//                   // ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
//                 ],
//               ),
//               SizedBox(height: 50),
//               Text('5674 karma • 1y'),
//               SizedBox(height: 10),
//               Text('description'),
//               SizedBox(height: 50),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
