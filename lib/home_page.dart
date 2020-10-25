import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new ListView(
        children: [
          // first cintainer..

          Container(
            margin: EdgeInsets.all(10.0),
            height: 70.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[700],
                  ),
                  child: Text(
                    'home',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 7.0,
          ),

          Container(
            margin: EdgeInsets.all(10.0),
            height: 400.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 390.0,
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          child: Image(
                            image: AssetImage('bein.png'),
                          ),
                        ),
                        Text('A rich text will be here'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 390.0,
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          child: Image(
                            image: AssetImage('dw.png'),
                          ),
                        ),
                        Text('A rich text '),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 390.0,
                    color: Colors.amber,
                    child: Column(
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          child: Image(
                            image: AssetImage('dw.png'),
                          ),
                        ),
                        Text('A rich text will be here'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
