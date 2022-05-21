import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/subscriptions/subscriptions_screen.dart';
import 'package:flutter_reddit_prototype/src/current_user/user_menu.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'home/home_screen.dart';
import 'inbox/inbox_screen.dart';
import 'submit/submit_screen.dart';

class Tabs extends StatelessWidget {
  Tabs({Key? key}) : super(key: key);

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
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
