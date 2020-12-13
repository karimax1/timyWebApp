import 'package:flutter/material.dart';
import 'package:timywebapp/models/userChannelLink.dart';
import 'package:provider/provider.dart';

class ChannelInfo extends StatefulWidget {
  @override
  _ChannelInfoState createState() => _ChannelInfoState();
}

class _ChannelInfoState extends State<ChannelInfo> {
  @override
  Widget build(BuildContext context) {
    final val = context.watch<UserChannelLink>();
    return Container(
      color: Colors.grey,
      child: Center(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            width: MediaQuery.of(context).size.width * 0.6,
            color: Colors.blueGrey,
            child: Center(
                child: Text(
              val.channelName,
              style: TextStyle(fontSize: 50.0, color: Colors.black),
            ))),
      ),
    );
  }
}
