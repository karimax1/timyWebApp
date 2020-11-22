import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannel {
  final String id;
  final String email;
  final String logoUrl;
  final String channelName;

  UserChannel({
    required this.id,
    required this.email,
    required this.logoUrl,
    required this.channelName,
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
