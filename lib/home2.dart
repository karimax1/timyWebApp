import 'package:flutter/material.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class Home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 2,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Container(
              width: 50,
              height: 50,
              child: Icon(Icons.support_agent),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Container(
              width: 50,
              height: 50,
              child: Icon(Icons.notifications_none),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Container(
              width: 50,
              height: 50,
              child: Image(
                image: AssetImage('mbc2.png'),
              ),
            ),
          ),
        ],
        title: Center(
          child: Text(
            'TimyTime',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Row(
        children: [
          _mainMenu(),
        ],
      ),
    );
  }

  _mainMenu() {
    return Container(
      height: double.infinity,
      width: 100,
      color: Colors.grey[900],
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            child: Image(
              image: AssetImage('mbc2.png'),
            ),
          ),
          VerticalTabs(
            tabsWidth: 90,
            tabs: <Tab>[
              Tab(
                child: Text('dashboard'),
              ),
              Tab(
                child: Text('Channel Info'),
              ),
              Tab(
                child: Text('Show Insert'),
              ),
              Tab(
                child: Text('Schedule'),
              ),
            ],
            contents: <Widget>[
              tabsContent('Dashborad'),
            ],
          ),
        ],
      ),
    );
  }

  Widget tabsContent(String caption, [String description = '']) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Text(
            caption,
            style: TextStyle(fontSize: 25),
          ),
          Divider(
            height: 20,
            color: Colors.black45,
          ),
          Text(
            description,
            style: TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
