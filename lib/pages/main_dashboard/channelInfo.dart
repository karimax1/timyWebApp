import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:language_pickers/language_pickers.dart';
import 'package:language_pickers/languages.dart';
import 'package:timywebapp/models/userChannelLink.dart';
import 'package:provider/provider.dart';
import 'package:timywebapp/style/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:timywebapp/style/hover_effects.dart';
import 'package:country_pickers/countries.dart';

class ChannelInfo extends StatefulWidget {
  @override
  _ChannelInfoState createState() => _ChannelInfoState();
}

class _ChannelInfoState extends State<ChannelInfo> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController sloganCont = TextEditingController();
  TextEditingController satFreqCont = TextEditingController();
  TextEditingController satNameCont = TextEditingController();
  TextEditingController webstreamCont = TextEditingController();
  TextEditingController youtubeCont = TextEditingController();
  TextEditingController fbCont = TextEditingController();
  TextEditingController instaCont = TextEditingController();
  TextEditingController coverLinkCont = TextEditingController();
  TextEditingController logoLinkCont = TextEditingController();
  TextEditingController descCont = TextEditingController();

  String _language, _genre, _hqCountry, _region, _image, error, id;

  double width;
  bool uploading;

  Uint8List data;

  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          _image = coverLinkCont.text = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });
    input.click();
  }

  Future<Uri> uploadFile(String ref, String fileName) async {
    try {
      StorageReference storageReference = storage().ref(ref).child(fileName);

      UploadTaskSnapshot uploadTaskSnapshot =
          await storageReference.put(data).future;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      return imageUri;
    } catch (e) {
      print('File Upload Error: $e');
      return null;
    }
  }

  List<String> languages = [];
  List<String> countries = [];
  @override
  void initState() {
    uploading = false;
    defaultLanguagesList.forEach((element) {
      languages.add(element['name']);
    });
    countryList.forEach((element) {
      countries.add(element.name);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width * 0.6;
    final val = context.watch<UserChannelLink>();
    return Container(
      color: Color.fromARGB(255, 27, 25, 27),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          width: width,
          padding: EdgeInsets.all(width * 0.05),
          color: Color.fromARGB(255, 35, 35, 35),
          child: SingleChildScrollView(
            child: Column(
              children: [
                val == null
                    ? Offstage()
                    : Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.network(
                            val.coverLink,
                            fit: BoxFit.fill,
                            width: width - (width * 0.05),
                          ),
                          Positioned(
                            bottom: -50,
                            left: 30,
                            child: Image.network(
                              val.logoLink,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                    child: FlatButton(
                      onPressed: () {
                        addChannelForm(val);
                      },
                      color: Colors.orange,
                      child: Text(
                        val != null ? 'Edit' : 'Add Channel',
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.orange, width: 2),
                      ),
                    ),
                  ),
                ),
                val == null
                    ? Offstage()
                    : Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(255, 144, 55, 134),
                                      Color.fromARGB(255, 81, 30, 92)
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      color: Colors.redAccent,
                                      child: Text(
                                        'Channel Details',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Genre: ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          val.genre,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Language: ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          val.mainLanguage,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(255, 144, 55, 134),
                                      Color.fromARGB(255, 81, 30, 92)
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3),
                                      color: Colors.redAccent,
                                      child: Text(
                                        'Stream Info',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Region: ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          val.broadcastRegion,
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Satelite: ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(val.sateliteName,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Frequency: ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(val.sateliteFrequency,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Web Stream: ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            if (await canLaunch(
                                                val.webStreamLink)) {
                                              await launch(val.webStreamLink);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Could not launch ${val.webStreamLink}');
                                            }
                                          },
                                          child: Text(
                                            'Click here',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ).showCursorHover,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                val == null
                    ? Offstage()
                    : Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(val.youtubeLink)) {
                                    await launch(val.youtubeLink);
                                  } else {
                                    await launch('https://' + val.youtubeLink);
                                  }
                                },
                                child: Icon(
                                    FaIcon(FontAwesomeIcons.youtube).icon,
                                    color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(val.fbLink)) {
                                    await launch(val.fbLink);
                                  } else {
                                    await launch('https://' + val.fbLink);
                                  }
                                },
                                child: Icon(
                                  FaIcon(FontAwesomeIcons.facebookF).icon,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  if (await canLaunch(val.instaLink)) {
                                    await launch(val.instaLink);
                                  } else {
                                    await launch('https://' + val.instaLink);
                                  }
                                },
                                child: Icon(
                                    FaIcon(FontAwesomeIcons.instagram).icon,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addChannelForm(UserChannelLink val) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
            width: width * 0.8,
            child: AlertDialog(
              backgroundColor: Color.fromARGB(255, 35, 35, 35),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Insert Channel Details',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              content: uploading
                  ? Loading()
                  : StatefulBuilder(builder: (context, setState) {
                      if (val != null) {
                        nameCont.text = val.channelName;
                        sloganCont.text = val.channelSlogan;
                        _genre = val.genre;
                        _language = val.mainLanguage;
                        _hqCountry = val.hqCountry;
                        _region = val.broadcastRegion;
                        satFreqCont.text = val.sateliteFrequency;
                        satNameCont.text = val.sateliteName;
                        webstreamCont.text = val.webStreamLink;
                        youtubeCont.text = val.youtubeLink;
                        fbCont.text = val.fbLink;
                        instaCont.text = val.instaLink;
                        descCont.text = val.description;
                        coverLinkCont.text = val.coverLink;
                        id = val.id;
                        setState(() {});
                      }
                      return Card(
                        color: Color.fromARGB(255, 35, 35, 35),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Insert all channel info here',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Channel Name',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: nameCont,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Channel Slogan',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: TextField(
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: sloganCont,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Genre',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black38)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 5,
                                                      top: 2,
                                                      bottom: 2),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    items: [
                                                      'Documentary',
                                                      'Movie',
                                                      'Show',
                                                      'Entertainment',
                                                      'News',
                                                      'Series',
                                                      'Sport'
                                                    ].map((e) {
                                                      return DropdownMenuItem(
                                                        value: e,
                                                        child: Text(e),
                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      _genre == null
                                                          ? 'Genre'
                                                          : _genre,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _genre = val;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Main Language',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black38)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 5,
                                                      top: 2,
                                                      bottom: 2),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    items: languages.map((e) {
                                                      return DropdownMenuItem(
                                                        value: e,
                                                        child: Text(e),
                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      _language == null
                                                          ? 'Select Language'
                                                          : _language,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _language = val;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'HQ Country',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black38)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 5,
                                                      top: 2,
                                                      bottom: 2),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    items: countries.map((e) {
                                                      return DropdownMenuItem(
                                                        value: e,
                                                        child: Text(e),
                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      _hqCountry == null
                                                          ? 'HQ Country'
                                                          : _hqCountry,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _hqCountry = val;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Broadcast Region',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black38)),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 5,
                                                      top: 2,
                                                      bottom: 2),
                                                  child: DropdownButton(
                                                    isExpanded: true,
                                                    items: ['MENA'].map((e) {
                                                      return DropdownMenuItem(
                                                        value: e,
                                                        child: Text(e),
                                                      );
                                                    }).toList(),
                                                    hint: Text(
                                                      _region == null
                                                          ? 'Broadcast Region'
                                                          : _region,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _region = val;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Satelite Frequency',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: satFreqCont,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Satelite Name',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: TextField(
                                                style: TextStyle(
                                                    color: Colors.white),
                                                controller: satNameCont,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            width: 1, color: Colors.black38)),
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Expanded(
                                            flex: (width * 0.2).round(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Web Stream Link',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: (width * 0.8).round(),
                                          child: Container(
                                            child: TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: webstreamCont,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            width: 1, color: Colors.black38)),
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Expanded(
                                            flex: (width * 0.2).round(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Youtube Link',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: (width * 0.8).round(),
                                          child: Container(
                                            child: TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: youtubeCont,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            width: 1, color: Colors.black38)),
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Expanded(
                                            flex: (width * 0.2).round(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Facebook Link',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: (width * 0.8).round(),
                                          child: Container(
                                            child: TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: fbCont,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            width: 1, color: Colors.black38)),
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Expanded(
                                            flex: (width * 0.2).round(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Instagram Link',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: (width * 0.8).round(),
                                          child: Container(
                                            child: TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: instaCont,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Channel Description',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                      child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: descCont,
                                    keyboardType: TextInputType.multiline,
                                    minLines: 2,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.white),
                                      ),
                                    ),
                                  )),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            width: 1, color: Colors.black38)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: (width * 0.1).round(),
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                'Upload Cover',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: (width * 0.75).round(),
                                          child: Container(
                                            child: TextField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: coverLinkCont,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: (width * 0.15).round(),
                                          child: Container(
                                            child: RaisedButton(
                                              color: Colors.transparent,
                                              onPressed: () async {
                                                pickImage();
                                              },
                                              child: Text(
                                                'Upload Cover',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FlatButton(
                                      splashColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: Colors.orange, width: 2),
                                      ),
                                      color: Colors.orange,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          uploading = true;
                                        });
                                        if (_formKey.currentState.validate()) {
                                          Uri uri;
                                          if (data != null) {
                                            uri = await uploadFile(
                                                'users', _image);
                                          }
                                          var reff = FirebaseFirestore.instance
                                              .collection('users');

                                          UserChannelLink channel =
                                              UserChannelLink(
                                            broadcastRegion: _region,
                                            channelName: nameCont.text,
                                            channelSlogan: sloganCont.text,
                                            coverLink: uri == null
                                                ? coverLinkCont.text
                                                : uri.toString(),
                                            description: descCont.text,
                                            fbLink: fbCont.text,
                                            genre: _genre,
                                            hqCountry: _hqCountry,
                                            id: '${id == null ? new Random().nextInt(100000) : id}',
                                            instaLink: instaCont.text,
                                            logoLink: logoLinkCont.text,
                                            mainLanguage: _language,
                                            sateliteFrequency: satFreqCont.text,
                                            sateliteName: satNameCont.text,
                                            webStreamLink: webstreamCont.text,
                                            youtubeLink: youtubeCont.text,
                                          );
                                          reff
                                              .doc(FirebaseAuth
                                                  .instance.currentUser.uid)
                                              .set(channel.toMap())
                                              .then((value) {
                                            setState(() {
                                              uploading = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: 'Channel Saved');
                                          }).catchError((error) {
                                            setState(() {
                                              uploading = false;
                                            });
                                            Fluttertoast.showToast(
                                                msg: 'Something went Wrong!');
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
            ),
          );
        });
  }
}
