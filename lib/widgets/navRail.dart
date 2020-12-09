import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timywebapp/models/userChannelLink.dart';
import 'package:timywebapp/pages/main_dashboard/channelInfo.dart';
import 'package:timywebapp/pages/main_dashboard/dashboard.dart';
import 'package:timywebapp/pages/main_dashboard/schedule.dart';
import 'package:timywebapp/pages/main_dashboard/shows.dart';
import 'package:timywebapp/authentication/auth_service.dart';
import 'package:provider/provider.dart';

final channelRef = FirebaseFirestore.instance.collection('users');

class NavRail extends StatefulWidget {
  final String profileId;
  NavRail({this.profileId});

  @override
  _NavRailState createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  int _selectedIndex = 0;
  final position = [
    Dashboard(),
    ChannelInfo(),
    Shows(),
    Schedule(),
  ];

  @override
  void initState() {
    //getChannels();

    super.initState();
  }

  // getChannels() async {
  //   // final String id = "0Hb6Wt5mMdY8AZZDzfkgMYMj4fv2";
  //   // final DocumentSnapshot doc = await channelRef.doc(id).get();
  //   final QuerySnapshot snapshot =
  //       await channelRef.where('genre', isEqualTo: 'Movie').get();
  //   snapshot.docs.forEach((DocumentSnapshot doc) {
  //     print(doc.data());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _channelData = Provider.of<Stream<List<UserChannelLink>>>(context);
    // return FutureBuilder(
    //     future: channelRef.doc().get(),
    //     builder: (context, AsyncSnapshot snapshot) {
    //       if (!snapshot.hasData) {
    //         return circularProgress();
    //       }
    //       UserChannelLink _channel =
    //           UserChannelLink.fromDocument(snapshot.data);
    //       print(_channel.channelName);
    return StreamProvider(
        create: (_) => _channelData,
        child: Builder(
          builder: (context) {
            final channelData = Provider.of<List<UserChannelLink>>(context);
            return Scaffold(
              appBar: AppBar(
                title: Center(child: Text('Timytime')),
                backgroundColor: Colors.grey[900],
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Image.network(channelData.first.logoLink),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(channelData.first.channelName),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton.icon(
                      onPressed: () async {
                        await context.read<AuthenticationService>().signOut();
                      },
                      icon: Icon(Icons.person),
                      color: Colors.white,
                      label: Text('Logout'),
                    ),
                  ),
                ],
              ),
              body: Row(
                children: [
                  Container(
                    width: 100,
                    child: NavigationRail(
                      backgroundColor: Colors.grey[800],
                      elevation: 4,
                      labelType: NavigationRailLabelType.all,
                      groupAlignment: -0.5,
                      destinations: [
                        NavigationRailDestination(
                            label: Text('Dashboard'),
                            icon: Icon(
                              Icons.stacked_bar_chart,
                              color: Colors.white,
                            )),
                        NavigationRailDestination(
                            label: Text('Channel Info'),
                            icon: Icon(
                              Icons.tv,
                              color: Colors.white,
                            )),
                        NavigationRailDestination(
                            label: Text('Shows'),
                            icon: Icon(
                              Icons.shop,
                              color: Colors.white,
                            )),
                        NavigationRailDestination(
                            label: Text('Schedule'),
                            icon: Icon(
                              Icons.schedule,
                              color: Colors.white,
                            )),
                      ],
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: position[_selectedIndex],
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }
}

// Container circularProgress() {
//   return Container(
//     alignment: Alignment.center,
//     padding: EdgeInsets.only(top: 10.0),
//     child: CircularProgressIndicator(
//       valueColor: AlwaysStoppedAnimation(Colors.purple),
//     ),
//   );
// }
