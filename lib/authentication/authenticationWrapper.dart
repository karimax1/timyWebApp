import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timywebapp/widgets/navRail.dart';
import 'package:timywebapp/pages/welcomePage.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final userId = context.watch<User>();
    final userId = Provider.of<User>(context);

    print(userId);

    if (userId == null) {
      return WelcomePage();
    } else {
      return NavRail();
    }
  }
}
