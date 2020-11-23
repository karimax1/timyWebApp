import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timywebapp/navRail.dart';
import 'package:timywebapp/pages/welcomePage.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    print(firebaseUser);

    if (firebaseUser == null) {
      return WelcomePage();
    } else {
      return NavRail();
    }
  }
}
