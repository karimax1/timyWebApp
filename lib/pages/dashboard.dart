import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: Colors.amberAccent,
      child: Container(
        width: double.infinity,
        height: 150,
        color: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120,
              width: 120,
              color: Colors.grey[500],
            ),
            Container(
              height: 120,
              width: 120,
              color: Colors.grey[500],
            ),
            Container(
              height: 120,
              width: 120,
              color: Colors.grey[500],
            ),
            Container(
              height: 120,
              width: 120,
              color: Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }
}
