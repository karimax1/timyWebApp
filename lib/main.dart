import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timywebapp/authentication/auth_service.dart';
import 'package:timywebapp/authentication/authenticationWrapper.dart';
import 'package:timywebapp/models/userChannelLink.dart';
import 'package:timywebapp/pages/not_found_page.dart';
import 'package:timywebapp/pages/main_dashboard/settings_page.dart';

Future<void> main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider<User>(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        ProxyProvider<User, CollectionReference>(
            update: (_, user, __) => linksCollection(user?.uid)),
        ProxyProvider<User, Stream<List<UserChannelLink>>>(
          update: (_, user, __) => userLinks(linksCollection(user?.uid)),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => AuthenticationWrapper(),
          '/settings': (context) => SettingsPage(),
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => NotFoundPage(routeName: settings.name),
        ),
      ),
    );
  }

  userLinks(CollectionReference linksCollection) {
    return linksCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserChannelLink.fromDocument(doc))
          .toList();
    });
  }

  CollectionReference linksCollection(String userId) =>
      FirebaseFirestore.instance.collection('users/$userId');
}
