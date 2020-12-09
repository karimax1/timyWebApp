import 'package:cloud_firestore/cloud_firestore.dart';

class ShowsModel {
  static const ID = "id";
  static const DESCRIPTION = "description";
  static const SHOWTITLE = "showTitle";
  static const CATEGORY = "category";
  static const CHANNELID = "channelUid";
  static const SHOWCOVERLINK = "showCoverLink";

  String _id;
  String _description;
  String _showTitle;
  String _category;
  String _showCoverLink;
  String _channelUid;

//  getters
  String get id => _id;

  String get description => _description;

  String get userId => _showTitle;

  String get category => _category;

  String get showCoverLink => _showCoverLink;

  String get channelUid => _channelUid;

  ShowsModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _showTitle = snapshot.data()[SHOWTITLE];
    _category = snapshot.data()[CATEGORY];
    _channelUid = snapshot.data()[CHANNELID];
    _showCoverLink = snapshot.data()[SHOWCOVERLINK];
  }
}
