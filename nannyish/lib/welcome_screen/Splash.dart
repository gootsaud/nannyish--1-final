import 'package:flutter/material.dart';
import 'package:nannyish/preferences/app_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      auth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/logo.jpg',
          height: 300,
        ),
      ),
    );
  }

  auth() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var uid = await prefs.getString("uid");
    // var Type = await prefs.getString("Type");
    // if (uid == null) {
    print('state Login ${AppPreferences().loggedIn}');
    if (!AppPreferences().loggedIn) {
      Navigator.pushReplacementNamed(context, 'login_screen');
    } else {
      var uid = AppPreferences().getUserData.uid;
      var Type = AppPreferences().getUserData.type;
      if (Type == "Nanny") {
        Navigator.of(context).pushNamedAndRemoveUntil(
          'Nav_n',
          (Route<dynamic> route) => false,
          arguments: {'uid': uid},
        );
      } else if (Type == "Parent") {
        Navigator.of(context).pushNamedAndRemoveUntil(
          'Nav_p',
          (Route<dynamic> route) => false,
          arguments: {'uid': uid},
        );
      }
    }
  }
}
