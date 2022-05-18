import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/preferences/app_preferences.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({required this.path, required this.nameUpdate});

  late var path;
  late String nameUpdate;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool runBtn = true;
  String _Q1 = '';
  String _Q2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[200],
        title: Text('Report',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'TimesNewRoman',
              fontSize: 23.0,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            )),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Why are you reporting account?',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Your report is anonymous, except of you\'re reporting an unstellectual property infringement. if somone is in immediate danger, call the local emergency services - don\'t wait.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
          ),
          ExpansionWidget(
            initiallyExpanded: false,
            titleBuilder:
                (double animationValue, _, bool isExpaned, toogleFunction) {
              return ElevatedButton(
                  onPressed: () => toogleFunction(animated: true),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white, elevation: 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                              'It\'s posting content that shouldn\'t be on nanniesh',
                              style: TextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 15,
                            )
                          ],
                        )),
                      ],
                    ),
                  ));
            },
            content: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: Text('It\'s spam'),
                        value: 'It\'s spam',
                        groupValue: _Q1,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q1 = value;
                            });
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Hate speech or symbols'),
                        value: 'Hate speech or symbols',
                        groupValue: _Q1,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q1 = value;
                            });
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Violence or dangerous organizations'),
                        value: 'Violence or dangerous organizations',
                        groupValue: _Q1,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q1 = value;
                            });
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Bullying or harassment'),
                        value: 'Bullying or harassment',
                        groupValue: _Q1,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q1 = value;
                            });
                          }
                        },
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (runBtn) {
                              if (_Q1.isNotEmpty) {
                                setState(() {
                                  runBtn = false;
                                  SVProgressHUD.show();
                                });
                                bool state = await FbFireStoreController()
                                    .createState(
                                        collectionName: 'report',
                                        uid: '${widget.path}${AppPreferences().getUserData.type}',
                                        data: {
                                      'reportByUserUID':
                                          AppPreferences().getUserData.uid,
                                      'reportByUserName':
                                          AppPreferences().getUserData.name,
                                      'reportByUserType':
                                          AppPreferences().getUserData.type,
                                      'requestUID': widget.path,
                                      'reportSelectQ':
                                          'It\'s posting content that shouldn\'t be on nanniesh',
                                      'reportSelectA': _Q1
                                    });
                                if (state) {
                                  bool state2 = await FbFireStoreController()
                                      .updateState(
                                          uid: widget.path,
                                          collectionName:
                                              'requestFromNanaToParent',
                                          data: {
                                        widget.nameUpdate: true,
                                      });
                                  if (state2) {
                                    SVProgressHUD.dismiss();
                                    Navigator.pop(context);
                                  }
                                } else {
                                  setState(() {
                                    runBtn = true;
                                  });
                                  SVProgressHUD.dismiss();
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.LEFTSLIDE,
                                          title: 'Error Save Report',
                                          btnCancelOnPress: () {})
                                      .show();
                                }
                              } else {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.LEFTSLIDE,
                                        title: 'Select Answer First',
                                        btnCancelOnPress: () {})
                                    .show();
                              }
                            }
                          },
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                              primary: (runBtn) ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ExpansionWidget(
            initiallyExpanded: false,
            titleBuilder:
                (double animationValue, _, bool isExpaned, toogleFunction) {
              return ElevatedButton(
                  onPressed: () => toogleFunction(animated: true),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white, elevation: 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                              'It\'s pretending to be someone else',
                              style: TextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 15,
                            )
                          ],
                        )),
                      ],
                    ),
                  ));
            },
            content: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: Text('Me'),
                        value: 'Me',
                        groupValue: _Q2,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q2 = value;
                            });
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('Someone I know'),
                        value: 'Someone I know',
                        groupValue: _Q2,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q2 = value;
                            });
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('A celebrity or public figure'),
                        value: 'A celebrity or public figure',
                        groupValue: _Q2,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q2 = value;
                            });
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: Text('A business or organization'),
                        value: 'A business or organization',
                        groupValue: _Q2,
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              _Q2 = value;
                            });
                          }
                        },
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (runBtn) {
                              if (_Q2.isNotEmpty) {
                                setState(() {
                                  runBtn = false;
                                });
                                SVProgressHUD.show();
                                bool state = await FbFireStoreController()
                                    .createState(
                                    collectionName: 'report',
                                    uid: '${widget.path}${AppPreferences().getUserData.type}',
                                    data: {
                                      'reportByUserUID':
                                      AppPreferences().getUserData.uid,
                                      'reportByUserName':
                                      AppPreferences().getUserData.name,
                                      'reportByUserType':
                                      AppPreferences().getUserData.type,
                                      'requestUID': widget.path,
                                      'reportSelectQ':
                                      'It\'s pretending to be someone else',
                                      'reportSelectA': _Q2
                                    });
                                if (state) {
                                  bool state2 = await FbFireStoreController()
                                      .updateState(
                                      uid: widget.path,
                                      collectionName:
                                      'requestFromNanaToParent',
                                      data: {
                                        widget.nameUpdate: true,
                                      });
                                  if (state2) {
                                    SVProgressHUD.dismiss();
                                    Navigator.pop(context);
                                  }
                                } else {
                                  setState(() {
                                    runBtn = true;
                                  });
                                  SVProgressHUD.dismiss();
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      animType: AnimType.LEFTSLIDE,
                                      title: 'Error Save Report',
                                      btnCancelOnPress: () {})
                                      .show();
                                }
                              } else {
                                AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    animType: AnimType.LEFTSLIDE,
                                    title: 'Select Answer First',
                                    btnCancelOnPress: () {})
                                    .show();
                              }
                            }
                          },
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                              primary: (runBtn) ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ExpansionWidget(
            initiallyExpanded: false,
            titleBuilder:
                (double animationValue, _, bool isExpaned, toogleFunction) {
              return ElevatedButton(
                  onPressed: () => toogleFunction(animated: true),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white, elevation: 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            Text(
                              'It may be under the age of 18',
                              style: TextStyle(color: Colors.black),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 15,
                            )
                          ],
                        )),
                      ],
                    ),
                  ));
            },
            content: Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: ()  async {
                            if (runBtn) {
                                setState(() {
                                  runBtn = false;
                                });
                                SVProgressHUD.show();
                                bool state = await FbFireStoreController()
                                    .createState(
                                    collectionName: 'report',
                                    uid: '${widget.path}${AppPreferences().getUserData.type}',
                                    data: {
                                      'reportByUserUID':
                                      AppPreferences().getUserData.uid,
                                      'reportByUserName':
                                      AppPreferences().getUserData.name,
                                      'reportByUserType':
                                      AppPreferences().getUserData.type,
                                      'requestUID': widget.path,
                                      'reportSelectQ':
                                      'It may be under the age of 18',
                                      'reportSelectA': ''
                                    });
                                if (state) {
                                  bool state2 = await FbFireStoreController()
                                      .updateState(
                                      uid: widget.path,
                                      collectionName:
                                      'requestFromNanaToParent',
                                      data: {
                                        widget.nameUpdate: true,
                                      });
                                  if (state2) {
                                    SVProgressHUD.dismiss();
                                    Navigator.pop(context);
                                  }
                                } else {
                                  SVProgressHUD.dismiss();
                                  setState(() {
                                    runBtn = true;
                                  });
                                  AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      animType: AnimType.LEFTSLIDE,
                                      title: 'Error Save Report',
                                      btnCancelOnPress: () {})
                                      .show();
                                }
                            }
                          },
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                              primary: (runBtn) ? Colors.blue : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
