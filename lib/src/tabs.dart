import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/subscriptions/subscriptions_screen.dart';
import 'package:flutter_reddit_prototype/src/user_menu.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'home/home_screen.dart';
import 'inbox/inbox_screen.dart';
import 'submit/submit_screen.dart';

class Tabs extends StatelessWidget {
  Tabs({Key? key}) : super(key: key);

  // TODO: remove
  Widget withScaffold(Widget body) {
    return body;
    // return Scaffold(
    //   drawer: UserMenu(),
    //   body: body,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: [
        HomeScreenV4(),
        SubscriptionsScreen(),
        Container(), // custom behavior
        InboxScreen(),
      ].map(withScaffold).toList(),
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
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
