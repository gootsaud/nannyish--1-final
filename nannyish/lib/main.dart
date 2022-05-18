import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nannyish/firebase/fb_notifications.dart';
import 'package:nannyish/welcome_screen/forget_password.dart';
import 'package:nannyish/nanny/Nanny.dart';
import 'package:nannyish/nanny/nav_n.dart';
import 'package:nannyish/parent/nav_p.dart';
import 'package:nannyish/parent/parent.dart';
import 'package:nannyish/registeration/register_as_nanny_screen.dart';
import 'package:nannyish/registeration/register_as_parent_screen.dart';
import 'package:nannyish/welcome_screen/welcome_screen.dart';
import 'preferences/app_preferences.dart';
import 'package:nannyish/welcome_screen/Splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51KeFcDDG7u6dEAF5uEVLgT3kkVZOobiEMhaLel7c9i3zGqfESV3wCAZhF8FAvW7LyAZcTx9A5nc90KsbbE6baknq00f1CSz81Q';
  await AppPreferences().initPreferences();
  await Firebase.initializeApp();
  await FbNotifications.initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nannyish',
      routes: {
        '/': (context) => const SplashScreen(),
        'login_screen': (context) => WelcomeScreen(),
        'Nanny': (context) => Nanny(),
        'parent': (context) => parent(),
        'registerParent': (context) => const RegisterAsParentScreen(),
        'registerNanny': (context) => const RegisterAsNannyScreen(),
        'forgetPassword': (context) => const ForgetPasswordScreen(),
        'Nav_p': (context) => nav_p(),
        'Nav_n': (context) => nav_n(),
      },
    );
  }
}

showMaterialDialog_login(context, name) {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AwesomeDialog(
    context: context,
    customHeader: ClipRRect(
      borderRadius: BorderRadius.circular(50.0),
      child: Scaffold(
        key: _scaffoldKey,
        body: InkWell(
          onTap: () {
            // Navigator.of(_scaffoldKey.currentContext).pop(true);
          },
          child: Image.asset(
            'assets/logo.jpg',
            fit: BoxFit.cover,
            width: 100,
          ),
        ),
      ),
    ),
    dialogType: DialogType.SUCCES,
    animType: AnimType.LEFTSLIDE,
    body: Text(name),
  ).show();
}
