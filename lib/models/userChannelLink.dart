import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannelLink {
  final String id;
  final String email;
  final String channelName;
  final String genre;
  final String logoLink;

  UserChannelLink({
    this.id,
    this.email,
    this.channelName,
    this.genre,
    this.logoLink,
  });

  factory UserChannelLink.fromDocument(DocumentSnapshot data) {
    return UserChannelLink(
      id: data.data()['id'],
      logoLink: data.data()['logoLink'],
      genre: data.data()['genre'],
      channelName: data.data()['channelName'],
    );
  }
  // final dummyData = [
  //   {'id': 'Mbc2', 'channelName': 'MBC1'}
  // ];
}
