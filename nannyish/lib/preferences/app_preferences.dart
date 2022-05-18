import 'dart:convert';
import 'package:nannyish/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static final AppPreferences _instance = AppPreferences._internal();
  late SharedPreferences _sharedPreferences;

  factory AppPreferences() {
    return _instance;
  }

  AppPreferences._internal();

  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Future<void> saveUid({required String uid , required String Type}) async {
  //   await _sharedPreferences.setString('uid', uid);
  //   await _sharedPreferences.setString('Type', Type);
  // }
  //
  bool get loggedIn => _sharedPreferences.getBool('logged_in') ?? false;

  Future<void> saveLogin({required Users users, required String uid}) async {
    await _sharedPreferences.setBool('logged_in', true);
    await _sharedPreferences.setString('uid', uid);
    await _sharedPreferences.setString('name', users.name);
    await _sharedPreferences.setString('email', users.email);
    await _sharedPreferences.setString('Type', users.type);
    await _sharedPreferences.setString('gender', users.gender);
    await _sharedPreferences.setString('identityID', users.identityID);
    await _sharedPreferences.setString('fcm', users.fcm);
    await _sharedPreferences.setString('photo', users.photoUrl);
    if (users.type == 'Nanny') {
      await _sharedPreferences.setString('experience', users.experience!);
      await _sharedPreferences.setString('birthdata', users.birthdata!);
      List<String> skills = [];
      for(String list in users.skills!){
        skills.add(list.toString());
        await _sharedPreferences.setStringList('skills', skills);
      }
    }
  }

  Users get getUserData {
    return Users.data(
      uid: _sharedPreferences.getString('uid') ?? '',
      name: _sharedPreferences.getString('name') ?? '',
      email: _sharedPreferences.getString('email') ?? '',
      type: _sharedPreferences.getString('Type') ?? '',
      gender: _sharedPreferences.getString('gender') ?? '',
      photoUrl: _sharedPreferences.getString('photo') ?? '',
      identityID: _sharedPreferences.getString('identityID') ?? '',
      experience: _sharedPreferences.getString('experience') ?? '',
      birthdata: _sharedPreferences.getString('birthdata') ?? '',
      fcm: _sharedPreferences.getString('fcm') ?? '',

      skills: _sharedPreferences.getStringList('skills') ?? [],

    );
  }

  Future<bool> logout() async {
    await _sharedPreferences.remove('logged_in');
    await _sharedPreferences.remove('uid');
    await _sharedPreferences.remove('name');
    await _sharedPreferences.remove('email');
    await _sharedPreferences.remove('Type');
    await _sharedPreferences.remove('gender');
    await _sharedPreferences.remove('photo');
    await _sharedPreferences.remove('identityID');
    await _sharedPreferences.remove('experience');
    await _sharedPreferences.remove('birthdata');
    await _sharedPreferences.remove('fcm');
    await _sharedPreferences.remove('skills');

    return true;
  }

  Future<void> saveAndChangeImageProfile({required String imageProfile}) async {
    await _sharedPreferences.setString('photo', imageProfile);
  }
  Future<void> saveAndChangeSkills({required List<String> list}) async {
    await _sharedPreferences.setStringList('skills', list);
  }

  Future<void> saveFcm({required String fcm}) async {
    await _sharedPreferences.setString('fcm', fcm);
  }

}
