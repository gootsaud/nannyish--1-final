import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nannyish/preferences/app_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nannyish/firebase/fb_auth_controller.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:rate_in_stars/rate_in_stars.dart';
import 'add_skills_screen.dart';
import '../../main.dart';

class Nanny extends StatefulWidget {
// String uid;
// LoginScreen(this.uid);
  @override
  State<Nanny> createState() => _NannyState();
}

class _NannyState extends State<Nanny> {
  late int nowYear;
  late int yearBirth;
  late int age;
  num averageRate = 0;

  XFile? _pickedFile;
  ImagePicker imagePicker = ImagePicker();
  String url = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nowYear = DateTime.now().toLocal().year;
    yearBirth = int.parse(
        AppPreferences().getUserData.birthdata.toString().split('-').first);
    age = nowYear - yearBirth;
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
                Container(
                  width: double.infinity,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                        width: 75.0,
                        height: 75.0,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage((AppPreferences()
                                    .getUserData
                                    .photoUrl
                                    .isEmpty)
                                ? "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png"
                                : AppPreferences().getUserData.photoUrl),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.transparent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
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
                          width: 200,
                          child: Divider(
                            color: Color.fromARGB(255, 5, 5, 5),
                            thickness: 1,
                          ),
                        ),
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
                                if(req.get('nanyId') == AppPreferences().getUserData.uid && req.get('NannyRate')!=''){
                                  averageRate =averageRate + req.get('NannyRate');
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
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.zero),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                      ),
                      Text(
                        'Years of experience:  ${AppPreferences().getUserData.experience.toString()}',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Age: ${age.toString()}',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 180,
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
                            const Padding(
                              padding: EdgeInsets.only(top: 8, left: 8),
                              child: Text(
                                'Skills:',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: 300,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: AppPreferences()
                                        .getUserData
                                        .skills!
                                        .length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        height: 30,
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(AppPreferences()
                                              .getUserData
                                              .skills![index]),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            primary: const Color(0xFFFAFAFA),
                            alignment: Alignment.center,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddSkillsScreen()));
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
                const SizedBox(
                  height: 80,
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
                                    btnOkOnPress: () async {})
                                .show();
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

  Future<void> pickImage() async {
    print('Start Function pickImage');
    _pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    if (_pickedFile != null) {
      bool editImageProfile = await uploadImage();
      if (editImageProfile) {
        print('done Upload To FireStorge');
        bool editUrlImage = await FbFireStoreController().updateState(
            uid: AppPreferences().getUserData.uid!,
            collectionName: 'users',
            data: {'photoUrl': url});
        if (editUrlImage) {
          await AppPreferences().saveAndChangeImageProfile(imageProfile: url);
          print('Done Save Url In FireStore');
          setState(() {});
        }
      }
    }
  }

  Future<bool> uploadImage() async {
    if (_pickedFile != null) {
      url = await postFile(imageFile: File(_pickedFile!.path));
      return true;
    } else {
      showMaterialDialog_login(context, 'select Image');
      return false;
    }
  }

  Future<String> postFile({required File imageFile}) async {
    String fileName = '${DateTime.now().toString().replaceAll(' ', '_')}';
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);
    String dowUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return dowUrl;
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

  /// رح يتم رفض الحذف في حال كان يوجد موعد مدفوع أو الناني مقدمة لعرض وتنتظر الرد
  Future<bool> canDeleteAccount() async {
    bool state = true;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('requestFromNanaToParent');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allData);
    for (Map<String, dynamic> item in allData) {
      if (item['nanyId'] == AppPreferences().getUserData.uid) {
        print('============== ${item['nanyId']} =============');
        if (item['response'].isNotEmpty) {
          if (item['response'] != 'REJECT' && item['response'] != 'Done') {
            state = false;
            break;
          }
        } else {
          state = false;
          break;
        }
      }
    }
    return state;
  }
}
