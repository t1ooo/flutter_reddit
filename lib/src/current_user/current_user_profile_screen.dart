import 'package:flutter/material.dart';

import '../user_profile/user_profile.dart';

class CurrentUserProfileScreen extends StatelessWidget {
  const CurrentUserProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserProfile();
  }
}
