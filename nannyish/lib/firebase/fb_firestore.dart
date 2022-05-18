import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:nannyish/main.dart';
import 'package:nannyish/users.dart';

class FbFireStoreController {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> read(
      {required String nameCollection,
      required String orderBy,
      required bool descending}) async* {
    yield* _firebaseFirestore
        .collection(nameCollection)
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }

  Stream<QuerySnapshot> readAll({
    required String nameCollection,
  }) async* {
    yield* _firebaseFirestore.collection(nameCollection).snapshots();
  }

  Future<bool> createUser(
      {required BuildContext context,
      required Users users,
      required String uid}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .set((users.type == 'Nanny') ? users.toMapNanny() : users.toMapParent())
        .then((value) {
      showMaterialDialog_login(
          context, 'The account has been created successfully.');
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<Users> getUserData({required String uid}) async {
    Users users = Users();
    final DocumentReference document =
        _firebaseFirestore.collection("users").doc(uid);
    await document.get().then<Users>((DocumentSnapshot snapshot) async {
      users.name = snapshot.get('name');
      users.email = snapshot.get('email');
      users.type = snapshot.get('type');
      users.identityID = snapshot.get('identityID');
      users.gender = snapshot.get('gender');
      users.photoUrl = snapshot.get('photoUrl');
      users.fcm = snapshot.get('fcm');
      if (users.type == 'Nanny') {
        users.birthdata = snapshot.get('Birthdata');
        users.experience = snapshot.get('experience');
        users.skills = snapshot.get('skills');
        print(snapshot.get('experience'));
      }
      return users;
    });
    return users;
  }

  Future<bool> createArray({required String nameDoc}) async {
    return await _firebaseFirestore
        .collection('kids')
        .doc(nameDoc)
        .set({'kidsList': []})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateArray(
      {required String nameDoc, required List<dynamic> data}) async {
    return await _firebaseFirestore
        .collection('kids')
        .doc(nameDoc)
        .update({'kidsList': FieldValue.arrayUnion(data)})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateArraySkills(
      {required String nameDoc, required List<dynamic> data}) async {
    return await _firebaseFirestore
        .collection('users')
        .doc(nameDoc)
        .update({'skills': FieldValue.arrayUnion(data)})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> addRequest({required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection('request')
        .doc()
        .set(data!)
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> createState(
      {required String uid,
        required String collectionName,
        required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection(collectionName)
        .doc(uid)
        .set(data!)
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> updateState(
      {required String uid,
      required String collectionName,
      required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection(collectionName)
        .doc(uid)
        .update(data!)
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> deleteState(
      {required String uid, required String collectionName}) async {
    return await _firebaseFirestore
        .collection(collectionName)
        .doc(uid)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> addRequestToParent({required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection('requestFromNanaToParent')
        .doc()
        .set(data!)
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  Future<bool> checkExists(
      {required String collection, required String doc}) async {
    var a = await _firebaseFirestore.collection(collection).doc(doc).get();
    if (a.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createChatCollection({required String nameDoc}) async {
    return await _firebaseFirestore
        .collection('chat')
        .doc(nameDoc)
        .collection('allMassages')
        .doc('1')
        .set({})
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> sendChat(
      {required String doc, required Map<String, dynamic>? data}) async {
    return await _firebaseFirestore
        .collection('chat')
        .doc(doc)
        .collection('allMassages')
        .doc()
        .set(data!)
        .then((value) {
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }


  Stream<QuerySnapshot> readChat(
      {required String doc,
        required String orderBy,
        required bool descending}) async* {
    yield* _firebaseFirestore
        .collection('chat')
        .doc(doc)
        .collection('allMassages')
        .orderBy(orderBy, descending: descending)
        .snapshots();
  }


}
