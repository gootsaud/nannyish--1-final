import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/admin/all_users_screen.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/nanny/Nanny.dart';
import 'package:nannyish/nanny/appointment_nanny.dart';
import 'package:nannyish/nanny/list_requests.dart';
import 'package:nannyish/nanny/myOffers_screen.dart';
import 'package:nannyish/preferences/app_preferences.dart';

class nav_n extends StatefulWidget {
  nav_n({Key? key}) : super(key: key);

  @override
  State<nav_n> createState() => _nav_nState();
}

class _nav_nState extends State<nav_n> {
  int currentIndex = 3;
  final List<Widget> screens = [
    FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"? AllUsersAdmin(): ListRequests(),
    AppointmentNanny(),
    MyOffer(),
    Nanny(),
  ];

  void _onTappedBar(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFcm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTappedBar,
        currentIndex: currentIndex,
        showSelectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy_outlined),
            label: 'Appoinment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'My offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Color(0xFFB3D0D7),
        unselectedItemColor: Colors.black,
      ),
    );
  }

  void getFcm() async {
    String? fcmNew = await FirebaseMessaging.instance.getToken() ?? '';
    String fcmOld = AppPreferences().getUserData.fcm;
    Map<String, dynamic> map = {'fcm' : fcmNew};

    if (fcmOld == fcmNew && fcmNew.isNotEmpty) {
      print('Equal Fcm');
    } else {
      bool state = await FbFireStoreController()
          .updateState(collectionName: 'users',uid: AppPreferences().getUserData.uid!, data: map);
      if (state) {
        AppPreferences().saveFcm(fcm: fcmNew);
        print('add Fcm => if');
      }
    }
  }
}
