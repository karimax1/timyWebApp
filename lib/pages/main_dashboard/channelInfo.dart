import 'package:flutter/material.dart';

class ChannelInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.6,
          color: Colors.blueGrey,
          //child: LayoutBuilder(builder: ,),
        ),
      ),
    );
  }
}
