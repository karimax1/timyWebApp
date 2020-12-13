import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timywebapp/authentication/auth_service.dart';
import 'package:timywebapp/models/showModel.dart';
import 'package:timywebapp/models/userChannelLink.dart';
import 'package:timywebapp/pages/main_dashboard/channelInfo.dart';
import 'package:timywebapp/pages/main_dashboard/dashboard.dart';
import 'package:timywebapp/pages/main_dashboard/schedule.dart';
import 'package:timywebapp/pages/main_dashboard/shows.dart';

final channelRef = FirebaseFirestore.instance.collection("users");
final showRef = FirebaseFirestore.instance.collection("shows");

class HomePage extends StatefulWidget {
  final String profileId;
  HomePage({this.profileId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final User user = FirebaseAuth.instance.currentUser;
  String userid;
  int showsCount = 0;

  final position = [Dashboard(), ChannelInfo(), Shows(), Schedule()];

  @override
  void initState() {
    userid = user.uid;
    getData(userid);

    //print(user.uid + " meeeee");

    super.initState();
  }

  DocumentSnapshot doc;

  getData(String userId) {
    channelRef.doc(userId).get().then((value) {
      setState(() {
        doc = value;
      });
      //print(doc.data()["channelName"]);
    });
  }

  getChannelShows() {
    showRef.doc(userid).get().then((value) {
      setState(() {
        doc = value;
      });
    });
  }

  // getChannelShows() async {
  //   QuerySnapshot snapshot = await showRef
  //       .doc(userid)
  //       .collection('shows')
  //       .orderBy('timestamp', descending: true)
  //       .get();
  //   setState(() {

  //     showsCount = snapshot.docs.length;
  //     showRef = snapshot.docs.map((doc) => ShowModel.fromDocument(doc)).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final _channelData = Provider.of<Stream<List<UserChannelLink>>>(context);
    return StreamProvider(
        create: (_) => _channelData,
        child: Builder(
          builder: (context) {
            if (doc == null) {
              return Scaffold(
                body: Container(child: Center(child: Text("Loading..."))),
              );
            }

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
                      child: Image.network(doc.data()["logoLink"]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(doc.data()["channelName"]),
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
