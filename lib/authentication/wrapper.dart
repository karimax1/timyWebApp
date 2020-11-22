import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timywebapp/models/userChannel.dart';
import 'package:timywebapp/navRail.dart';
import 'package:timywebapp/pages/welcomePage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserChannel>(context);
    print(user);

    if (user == null) {
      return WelcomePage();
    } else {
      return NavRail();
    }
  }
}
