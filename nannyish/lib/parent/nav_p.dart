import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/admin/all_report_screen.dart';
import 'package:nannyish/admin/all_users_screen.dart';
import 'package:nannyish/parent/appoinment.dart';
import 'package:nannyish/parent/list.dart';
import 'package:nannyish/parent/parent.dart';
import 'package:nannyish/parent/view_offers.dart';

class nav_p extends StatefulWidget {
  nav_p({Key? key}) : super(key: key);

  @override
  State<nav_p> createState() => _nav_pState();
}

class _nav_pState extends State<nav_p> {
  int currentIndex = 3;
  final List<Widget> screens = [
    FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"? AllUsersAdmin(): list(),
    FirebaseAuth.instance.currentUser!.uid == "4HLU8AWAfdR6JKn1s2aSXAtMC3a2"? AllReportsAdmin(): Appoinment(),
    ViewOffers(),
    parent(),
  ];

  void _onTappedBar(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTappedBar,
        currentIndex: currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.copy_outlined),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.border_all),
            label: 'Offers',
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
}
