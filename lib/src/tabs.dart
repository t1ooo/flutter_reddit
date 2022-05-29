import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'home/home_screen.dart';
import 'inbox/inbox_screen.dart';
import 'submit/submit_screen.dart';
import 'subscriptions/subscriptions_screen.dart';

class Tabs extends StatelessWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: [
        HomeScreen(),
        SubscriptionsScreen(),
        Container(),
        InboxScreen(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.grid_view),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.edit),
          onPressed: (_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubmitScreen(),
              ),
            );
          },
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.mail),
        ),
      ],
      resizeToAvoidBottomInset: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10),
        colorBehindNavBar: Colors.white,
      ),
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
