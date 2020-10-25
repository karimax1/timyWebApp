import 'package:flutter/material.dart';
import 'package:vertical_tabs/vertical_tabs.dart';

class Home3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Title',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Timytime')),
          backgroundColor: Colors.grey[900],
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: double.infinity,
                  width: 150,
                  color: Colors.grey[800],
                  child: Column(
                    children: [
                      Container(
                        width: 150,
                        height: 70,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: Image(
                                image: AssetImage('mbc2.png'),
                              ),
                            ),
                            Text(
                              'MBC 2',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: VerticalTabs(
                  tabsWidth: 100,
                  tabs: <Tab>[
                    Tab(
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  contents: <Widget>[
                    Container(
                        child: Text('Flutter'), padding: EdgeInsets.all(20)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
