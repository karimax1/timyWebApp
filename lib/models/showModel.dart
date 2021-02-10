import 'package:cloud_firestore/cloud_firestore.dart';

class ShowModel {
  final String id;
  final String channelUid;
  final String showTitle;
  final String mainLanguage;
  final String showDescription;
  final String showCoverLink;
  final String category;
  final String subtitle;
  final Timestamp premier;
  final Timestamp replay;
  final String trailerLink;
  final List<String> tags;
  final Timestamp createdAt;
  final Timestamp startDateBroadcastTime;
  final Timestamp endDateBroadcastTime;
  final String sportType;
  final String broadcastTime;

  ShowModel(
      {this.id,
      this.channelUid,
      this.showTitle,
      this.mainLanguage,
      this.showDescription,
      this.showCoverLink,
      this.category,
      this.subtitle,
      this.premier,
      this.replay,
      this.trailerLink,
      this.tags,
      this.broadcastTime,
      this.createdAt,
      this.endDateBroadcastTime,
      this.sportType,
      this.startDateBroadcastTime});

  Map<String, dynamic> toDoc() {
    return {
      'id': id,
      'channelUid': channelUid,
      'showTitle': showTitle,
      'mainLanguage': mainLanguage,
      'showDescription': showDescription,
      'showCoverLink': showCoverLink,
      'category': category,
      'subtitle': subtitle,
      'premier': premier,
      'trailerLink': trailerLink,
      'tags': tags,
      'broadcastTime': broadcastTime,
      'createdAt': createdAt,
      'endDateBroadcastTime': endDateBroadcastTime,
      'startDateBroadcastTime': startDateBroadcastTime,
      'sportType': sportType
    };
  }

  factory ShowModel.fromDocument(Map<dynamic, dynamic> doc) {
    return ShowModel(
        id: doc['id'],
        channelUid: doc['channelUid'],
        showTitle: doc['showTitle'],
        mainLanguage: doc['mainLanguage'],
        showDescription: doc['showDescription'],
        showCoverLink: doc['showCoverLink'],
        category: doc['category'],
        subtitle: doc['subtitle'],
        premier: doc['premier'],
        replay: doc['trailerLink'],
        tags: doc['tags'],
        broadcastTime: doc['broadcastTime'],
        createdAt: doc['createdAt'],
        startDateBroadcastTime: doc['startDateBroadcastTime'],
        endDateBroadcastTime: doc['endDateBroadcastTime'],
        sportType: doc['sportType']);
  }
}
