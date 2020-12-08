import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannelLink {
  final String id;
  final String logoLink;
  final String channelName;
  final DocumentReference documentReference;

  UserChannelLink({
    this.id,
    this.logoLink,
    this.channelName,
    this.documentReference,
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
      documentReference: document.reference,
    );

    // factory UserChannelLink.fromDocument(QueryDocumentSnapshot data) {
    //   return UserChannelLink(
    //     id: data.data()['id'],
    //     logoLink: data.data()['logoLink'],
    //     channelName: data.data()['channelName'],
    //   );
    // }
    // final dummyData = [
    //   {'id': 'Mbc2', 'channelName': 'MBC1'}
    // ];
  }
}
