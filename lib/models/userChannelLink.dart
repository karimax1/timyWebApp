import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserChannelLink {
  final String id;
  final String logoLink;
  final String channelName;

  UserChannelLink({
    this.id,
    this.logoLink,
    this.channelName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logoLink': logoLink,
      'channelName': channelName,
    };
  }

  static UserChannelLink fromDocument(DocumentSnapshot document) {
    if (document == null || document.data == null) return null;

    return UserChannelLink(
      id: document.id,
      channelName: document.data()['channelName'],
      logoLink: document.data()['logoLink'],
    );
  }
}
