import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/main.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController Email = new TextEditingController();
  bool Progress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 110,
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/logo.jpg',
                      ),
                    ),
                    Text(
                      'Welcome to Nannyish',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Please your email to send you the code:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: Email,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        fillColor: Color(0xFFEEEEEE),
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'your email',
                        hintStyle: TextStyle(
                          fontFamily: 'TimesNewRoman',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'login_screen');
                            },
                            child: const Text('BACK TO LOGIN'),
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
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: Progress == false
                                ? () async {
                                    if (Email.text.trim().isNotEmpty) {
                                      setState(() {
                                        Progress = true;
                                      });
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: Email.text);
                                        print("sendPasswordResetEmail");
                                        Navigator.pushNamed(
                                            context, 'login_screen');
                                      } on FirebaseAuthException catch (e) {
                                        print(e.code);
                                        print(e.message);
                                      }
                                      setState(() {
                                        Progress = false;
                                      });
                                    } else {
                                      showMaterialDialog_login(
                                          context, "Enter your Email");
                                    }
                                  }
                                : () {},
                            child: Progress == false
                                ? Text('SEND CODE')
                                : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'MeltowSan300',
                              ),
                              primary: Color(0xFF455A64),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      const BorderRadius.all(Radius.zero)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
