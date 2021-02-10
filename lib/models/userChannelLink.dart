import 'package:cloud_firestore/cloud_firestore.dart';

class UserChannelLink {
  final String id;
  final String logoLink;
  final String channelName;
  final String coverLink;
  final String channelSlogan;
  final String broadcastRegion;
  final String description;
  final String fbLink;
  final String genre;
  final String hqCountry;
  final String mainLanguage;
  final String instaLink;
  final String youtubeLink;
  final String sateliteName;
  final String sateliteFrequency;
  final String webStreamLink;

  UserChannelLink({
    this.id,
    this.logoLink,
    this.channelName,
    this.broadcastRegion,
    this.channelSlogan,
    this.coverLink,
    this.description,
    this.fbLink,
    this.genre,
    this.hqCountry,
    this.mainLanguage,
    this.instaLink,
    this.youtubeLink,
    this.sateliteFrequency,
    this.sateliteName,
    this.webStreamLink,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logoLink': logoLink,
      'channelName': channelName,
      'description': description,
      'genre': genre,
      'channelSlogan': channelSlogan,
      'broadcastRegion': broadcastRegion,
      'hqCountry': hqCountry,
      'coverLink': coverLink,
      'fbLink': fbLink,
      'instaLink': instaLink,
      'youtubeLink': youtubeLink,
      'sateliteFrequency': sateliteFrequency,
      'sateliteName': sateliteName,
      'webStreamLink': webStreamLink,
      'mainLanguage': mainLanguage,
    };
  }

  static UserChannelLink fromDocument(DocumentSnapshot document) {
    if (document == null || document.data == null) return null;

    return UserChannelLink(
      id: document.id,
      channelName: document.data()['channelName'],
      logoLink: document.data()['logoLink'],
      broadcastRegion: document.data()['broadcastRegion'],
      channelSlogan: document.data()['channelSlogan'],
      coverLink: document.data()['coverLink'],
      description: document.data()['description'],
      fbLink: document.data()['fbLink'],
      genre: document.data()['genre'],
      hqCountry: document.data()['hqCountry'],
      instaLink: document.data()['instaLink'],
      youtubeLink: document.data()['youtubeLink'],
      sateliteFrequency: document.data()['sateliteFrequency'],
      sateliteName: document.data()['sateliteName'],
      webStreamLink: document.data()['webStreamLink'],
      mainLanguage: document.data()['mainLanguage'],
    );
  }
}
