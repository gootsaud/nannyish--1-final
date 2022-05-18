import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/parent/addKids.dart';
import 'package:nannyish/preferences/app_preferences.dart';
import 'package:nannyish/firebase/fb_auth_controller.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class parent extends StatefulWidget {
  parent({Key? key}) : super(key: key);
  @override
  State<parent> createState() => _parentState();
}

class _parentState extends State<parent> {
  num averageRate = 0;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"?
                    SizedBox(height: 300,):SizedBox(),
                Container(
                  width: double.infinity,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppPreferences().getUserData.name,
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        SizedBox(
                          width: 260,
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                        if(FirebaseAuth.instance.currentUser!.uid != "4HLU8AWAfdR6JKn1s2aSXAtMC3a2")
                        StreamBuilder<QuerySnapshot>(
                          stream: FbFireStoreController().readAll(
                              nameCollection: 'requestFromNanaToParent'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              List<QueryDocumentSnapshot> data =
                                  snapshot.data!.docs;
                              int sum = 0;
                              for (var req in data) {
                                if(req.get('ParentId') == AppPreferences().getUserData.uid && req.get('ParentRate')!=''){
                                  averageRate = averageRate + req.get('ParentRate');
                                  sum++;
                                }
                              }

                              return RatingStars(
                                editable: false,
                                rating: averageRate/sum,
                                color: Colors.amber,
                                iconSize: 32,
                              );
                            } else {
                              return Text("No Rates Yet");
                            }
                          },
                        ),
                        Text(
                          FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"?AppPreferences().getUserData.email: "",
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"?Row(
                          children: [
                            SizedBox(height: 35,),
                            Text("Account Type : "),
                            Text(FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"?"Admin":AppPreferences().getUserData.type),
                          ],
                        ):SizedBox()
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"?SizedBox(height: 50,):
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.zero),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8, left: 8),
                              child: Row(
                                children: [
                                  Text(
                                    'kids:',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 30,
                                    margin: EdgeInsets.only(right: 0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        primary: Colors.white,
                                        alignment: Alignment.center,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddKidsScreen()));
                                      },
                                      child: const Icon(
                                        Icons.add_circle_outlined,
                                        color: Colors.black,
                                        // size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder(
                              future: getKids(),
                              builder: (index, AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  List<dynamic> kids =
                                      snapshot.data['kidsList'];
                                  if (kids.length != 0) {
                                    return Expanded(
                                      child: ListView.builder(
                                        itemCount: kids.length,
                                        itemBuilder: (context, index) {
                                          print(index);
                                          String name = kids[index]
                                              .toString()
                                              .substring(
                                                  kids[index]
                                                          .toString()
                                                          .indexOf('Name:') +
                                                      5,
                                                  kids[index]
                                                      .toString()
                                                      .indexOf('/Age:'));
                                          String years = kids[index]
                                              .toString()
                                              .substring(
                                                  kids[index]
                                                          .toString()
                                                          .indexOf('Age:') +
                                                      4,
                                                  kids[index]
                                                      .toString()
                                                      .indexOf('/Notes:'));
                                          String notes = kids[index]
                                              .toString()
                                              .substring(kids[index]
                                                      .toString()
                                                      .indexOf('Notes:') +
                                                  6);
                                          return informationKids(
                                            name: name,
                                            notes: notes,
                                            years: years,
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(AppPreferences().getUserData.uid);
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.WARNING,
                        animType: AnimType.BOTTOMSLIDE,
                        desc: 'You are logging out \nare you sure?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          FbAuthController().signOut(context);
                        },
                      )..show();

                      // AlertDialogWidget();
                    },
                    child: const Text('LOG OUT'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'MeltowSan300',
                      ),
                      primary: Color(0xFF455A64),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"?SizedBox():
                SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.QUESTION,
                        animType: AnimType.BOTTOMSLIDE,
                        desc: 'Are you sure you want to delete your account?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          loadingDialog(context, true);
                          bool state = await canDeleteAccount();
                          if (state) {
                            loadingDialog(context, false);
                            FbAuthController().DeleteAccount(context);
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .delete();
                          } else {
                            loadingDialog(context, false);
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.BOTTOMSLIDE,
                                desc:
                                    'You cannot delete the account, there are open dates',
                                btnOkOnPress: () async {
                                }).show();
                          }
                        },
                      ).show();
                    },
                    child: const Text('Delete my account'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'MeltowSan300',
                      ),
                      primary: Color(0xFF455A64),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget informationKids(
      {required String name,
      required String years,
      required String notes,
      bool check = true}) {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.zero),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, border: Border.all()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              )),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    '${years} years',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: Text(
                    'Notes : ${notes}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getKids() async {
    var data;
    DocumentReference doc_ref = FirebaseFirestore.instance
        .collection("kids")
        .doc(AppPreferences().getUserData.uid);
    await doc_ref.get().then((value) {
      data = value.data();
    });
    print(data);
    return data;
  }

  AlertDialogWidget() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Log out',
          ),
          content: Text(
            'You are logging out \nare you sure?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                FbAuthController().signOut(context);
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        );
      },
    );
  }

  void loadingDialog(BuildContext context, bool run) {
    if (run)
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    else {
      Navigator.pop(context);
    }
  }

  Future<bool> canDeleteAccount() async {
    bool state = true;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('requestFromNanaToParent');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    for (Map<String, dynamic> item in allData) {
      if (item['ParentId'] == AppPreferences().getUserData.uid) {
        print('============== ${item['ParentId']} =============');
        if (item['response'].isNotEmpty) {
          if (item['response'] != 'REJECT' && item['response'] != 'Done') {
            state = false;
            break;
          }
        }
      }
    }
    return state;
  }
}
