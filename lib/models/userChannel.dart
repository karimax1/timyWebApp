import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannel {
  final String id;
  final String logoLink;
  final String channelName;

  UserChannel({
    this.id,
    this.logoLink,
    this.channelName,
  });

  factory UserChannel.fromDocument(DocumentSnapshot doc) {
    return UserChannel(
      id: doc['id'],
      logoLink: doc['logoLink'],
      channelName: doc['channelName'],
    );
  }
}
