import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowModel {
  final String id;
  final String channelUid;
  final String showTitle;
  final String mainLanguage;
  final String description;
  final String showCoverLink;

  ShowModel({
    this.id,
    this.channelUid,
    this.showTitle,
    this.mainLanguage,
    this.description,
    this.showCoverLink,
  });

  factory ShowModel.fromDocument(DocumentSnapshot doc) {
    return ShowModel(
      id: doc['id'],
      channelUid: doc['channelUid'],
      showTitle: doc['showTitle'],
      mainLanguage: doc['mainLanguage'],
      description: doc['description'],
      showCoverLink: doc['showCoverLink'],
    );
  }
}
