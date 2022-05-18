import 'dart:math';

class Users {
  late String? uid;
  late String name;
  late String email;
  late String type;
  late String identityID;
  late String gender;
  late String fcm;
  late String photoUrl;
  late String? experience;
  late String? birthdata;
  late List <dynamic>? skills;
  late bool? isActivate;

  Users();

  Users.data(
      {this.uid,
      this.isActivate,
      required this.name,
      required this.email,
      required this.type,
      required this.identityID,
        required this.fcm,
        required this.gender,
      required this.photoUrl,
      this.experience,
       this.skills,
      this.birthdata});

  Map<String, dynamic> toMapNanny() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['isActivate'] = isActivate;
    map['email'] = email;
    map['type'] = type;
    map['identityID'] = identityID;
    map['gender'] = gender;
    map['photoUrl'] = '';
    map['Birthdata'] = birthdata;
    map['fcm'] = fcm;
    map['experience'] = experience;
    map['skills'] = [];
    return map;
  }

  Map<String, dynamic> toMapParent() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['name'] = name;
    map['isActivate'] = isActivate;
    map['email'] = email;
    map['type'] = type;
    map['identityID'] = identityID;
    map['gender'] = gender;
    map['photoUrl'] = '';
    map['fcm'] = '';

    return map;
  }
}
