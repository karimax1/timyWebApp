import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:language_pickers/languages.dart';
import 'package:timywebapp/models/showModel.dart';
import 'package:firebase/firebase.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:timywebapp/style/loading.dart';
import 'package:language_pickers/language_picker_dropdown.dart';

class Shows extends StatefulWidget {
  @override
  _ShowsState createState() => _ShowsState();
}

class _ShowsState extends State<Shows> {
  final format = DateFormat("MMMM dd,yyyy 'at' HH:mm:ss a");

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleCont = TextEditingController();
  TextEditingController descCont = TextEditingController();
  TextEditingController premierCont = TextEditingController();
  TextEditingController replayCont = TextEditingController();
  TextEditingController trailerCont = TextEditingController();
  TextEditingController tagsCont = TextEditingController();
  TextEditingController coverLinkCont = TextEditingController();
  String _category, _subtitle, _language, _image = '', error;
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
          _image = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });
    input.click();
  }

  CollectionReference reff;
  bool uploading;

  Future<Uri> uploadFile(String ref, String fileName) async {
    try {
      StorageReference storageReference = storage().ref(ref).child(fileName);

      UploadTaskSnapshot uploadTaskSnapshot =
          await storageReference.put(data).future;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      return imageUri;
    } catch (e) {
      return null;
    }
  }

  Future<String> uploadShow() async {
    Uri uri = await uploadFile('shows', _image);
    if (uri == null) {
      return "Image Upload Failed!";
    }
    ShowModel show = ShowModel(
        channelUid: FirebaseAuth.instance.currentUser.uid,
        id: '${new Random().nextInt(100000)}',
        category: _category,
        showDescription: descCont.text,
        mainLanguage: _language,
        premier: Timestamp.fromDate(format.parse(premierCont.text)),
        replay: Timestamp.fromDate(format.parse(replayCont.text)),
        showTitle: titleCont.text,
        showCoverLink: uri.toString(),
        tags: tagsCont.text.split(','),
        subtitle: _subtitle,
        trailerLink: trailerCont.text);
    reff.add(show.toDoc()).then((value) {
      return "Show Added";
    }).catchError((error) {
      return error.toString();
    });
  }

  ShowModel sample;
  List<ShowModel> shows;
  loadShows() async {
    reff
        .where("channelUid", isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      sample = ShowModel.fromDocument(value.docs[0].data());
      shows = [];
      value.docs.forEach((element) {
        shows.add(ShowModel.fromDocument(element.data()));
      });
      setState(() {});
    });
  }

  List<String> languages = [];
  @override
  void initState() {
    reff = FirebaseFirestore.instance.collection('shows');
    defaultLanguagesList.forEach((element) {
      languages.add(element['name']);
    });
    loadShows();

    uploading = false;
    super.initState();
  }

  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: width,
        color: Color.fromARGB(255, 27, 25, 27),
        child: Stack(
          children: [
            Container(
              color: Color.fromARGB(255, 27, 25, 27),
              padding: EdgeInsets.all(10),
              child: FlatButton(
                onPressed: () {
                  addShowForm();
                },
                color: Colors.orange,
                child: Text(
                  'Add New Show',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 10, right: 10),
              color: Color.fromARGB(255, 27, 25, 27),
              child: shows == null
                  ? Loading()
                  : GridView.count(
                      primary: true,
                      physics: ScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: width > 1000 ? 3 : 2,
                      scrollDirection: Axis.vertical,
                      children: List.generate(
                        shows.length,
                        (index) {
                          return Align(
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: Wrap(
                                children: [
                                  Container(
                                    child: Image.network(
                                      shows.elementAt(index).showCoverLink,
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: double.maxFinite,
                                      repeat: ImageRepeat.noRepeat,
                                    ),
                                  ),
                                  Container(
                                    color: Color.fromARGB(255, 35, 35, 35),
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  shows
                                                      .elementAt(index)
                                                      .showTitle,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  shows
                                                      .elementAt(index)
                                                      .showDescription,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  'Premier: ${format.format(shows.elementAt(index).premier.toDate())}',
                                                  style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            )),
                                        Container(
                                          width: 70,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: FlatButton(
                                                  color: Colors.transparent,
                                                  onPressed: () {},
                                                  child: Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors.orange),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: BorderSide(
                                                        color: Colors.orange,
                                                        width: 2),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: FlatButton(
                                                  color: Colors.orange,
                                                  onPressed: () {},
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: BorderSide(
                                                        color: Colors.orange,
                                                        width: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  addShowForm() {
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
                      'Insert Show Details',
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
                                    'Insert all show info here',
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
                                              'Show Title',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            TextFormField(
                                              validator: (val) {
                                                if (val.isEmpty) {
                                                  return 'Title is required!';
                                                }
                                                return null;
                                              },
                                              style: TextStyle(
                                                  color: Colors.white),
                                              controller: titleCont,
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
                                              'Category',
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
                                                      _category == null
                                                          ? 'Select a category'
                                                          : _category,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _category = val;
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Subtitle',
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
                                                      _subtitle == null
                                                          ? 'Not Available'
                                                          : _subtitle,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _subtitle = val;
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
                                  Text(
                                    'Show Description',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                      child: TextField(
                                    controller: descCont,
                                    style: TextStyle(color: Colors.white),
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
                                  Text(
                                    'Premier',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    child: DateTimeField(
                                      format: format,
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));
                                        if (date != null) {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(
                                                currentValue ?? DateTime.now()),
                                          );
                                          return DateTimeField.combine(
                                              date, time);
                                        } else {
                                          return currentValue;
                                        }
                                      },
                                      validator: (val) {
                                        if (val == null) {
                                          return "Premier Date is required!";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(color: Colors.white),
                                      controller: premierCont,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Replay',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    child: DateTimeField(
                                      format: format,
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final date = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));
                                        if (date != null) {
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(
                                                currentValue ?? DateTime.now()),
                                          );
                                          return DateTimeField.combine(
                                              date, time);
                                        } else {
                                          return currentValue;
                                        }
                                      },
                                      style: TextStyle(color: Colors.white),
                                      controller: replayCont,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.white),
                                        ),
                                      ),
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
                                                'Trailer Link',
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
                                              controller: trailerCont,
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
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: TextField(
                                        style: TextStyle(color: Colors.white),
                                        controller: tagsCont,
                                        decoration: InputDecoration(
                                          labelText: 'Tags',
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
                                            child: TextFormField(
                                              validator: (val) {
                                                if (val.isEmpty) {
                                                  return 'Cover image is required!';
                                                }
                                                return null;
                                              },
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
                                              onPressed: () {},
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
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            uploading = true;
                                          });
                                          String res = await uploadShow();
                                          setState(() {
                                            uploading = false;
                                          });
                                          if (res == 'Show Added') {
                                            Navigator.of(context).pop(true);
                                          }
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
