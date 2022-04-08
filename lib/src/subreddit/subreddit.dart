import 'package:flutter/material.dart';

import '../reddit_api/subreddit.dart';
import '../style/style.dart';
import '../widget/sized_placeholder.dart';

class SubredditWidget extends StatelessWidget {
  const SubredditWidget({
    Key? key,
    required this.subreddit,
  }) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(subreddit.displayNamePrefixed, textScaleFactor: 2),
                  Spacer(),
                  ElevatedButton(onPressed: () {}, child: Icon(Icons.doorbell)),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: Text('JOINED')),
                ],
              ),
              SizedBox(height: 20),
              Text('${subreddit.subscribers} members'),
              SizedBox(height: 20),
              Text(subreddit.publicDescription),
              
              /* Row(
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
              SizedBox(height: 20), */
            ],
          ),
        ),
      ],
    );
  }
}
