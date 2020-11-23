import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannel {
  final String id;
  final String email;
  final String logoUrl;
  final String channelName;

  UserChannel({
    this.id,
    this.email,
    this.logoUrl,
    this.channelName,
  });

  factory UserChannel.fromDocument(DocumentSnapshot doc) {
    return UserChannel(
      id: doc['id'],
      email: doc['email'],
      logoUrl: doc['logoLink'],
      channelName: doc['channelName'],
    );
  }
}
