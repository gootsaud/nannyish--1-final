import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nannyish/main.dart';
import 'package:nannyish/firebase/fb_auth_controller.dart';
import 'package:nannyish/users.dart';

class RegisterAsNannyScreen extends StatefulWidget {
  const RegisterAsNannyScreen({Key? key}) : super(key: key);

  @override
  State<RegisterAsNannyScreen> createState() => _RegisterAsNannyScreenState();
}

class _RegisterAsNannyScreenState extends State<RegisterAsNannyScreen> {
  TextEditingController Email = new TextEditingController();
  TextEditingController Name = new TextEditingController();
  TextEditingController Identity_ID = new TextEditingController();
  TextEditingController experience = new TextEditingController();
  TextEditingController Birthdata = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool Progress = false;
  var Gender;

  var date_paker_v1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 110,
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Image.asset(
                        'assets/logo.jpg',
                      ),
                      const Text(
                        'Welcome to Nannyish',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Please fill these Information:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Identity ID:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: Identity_ID,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          fillColor: Color(0xFFEEEEEE),
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'Input Field',
                          hintStyle: TextStyle(
                            fontFamily: 'TimesNewRoman',
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Email:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
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
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontFamily: 'TimesNewRoman',
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'First and last name:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: Name,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          fillColor: Color(0xFFEEEEEE),
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'First and last name',
                          hintStyle: TextStyle(
                            fontFamily: 'TimesNewRoman',
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Password:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: password,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          fillColor: Color(0xFFEEEEEE),
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontFamily: 'TimesNewRoman',
                          ),
                        ),
                      ),
                      // SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 130,
                            height: 80,
                            child: Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Gender:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 5),
                                  DropdownButtonFormField(
                                      isDense: true,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                      hint: const DropdownMenuItem(
                                        child: Text(
                                          'Female or male',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      onChanged: (s) {
                                        setState(() {
                                          Gender = s;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 10,
                                        ),
                                        border: InputBorder.none,
                                        filled: true,
                                        fillColor: Color(0xFFEEEEEE),
                                      ),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      items: [
                                        DropdownMenuItem(
                                          value: 0,
                                          child: Text('Male'),
                                        ),
                                        DropdownMenuItem(
                                          value: 1,
                                          child: Text('Female'),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 130,
                            height: 80,
                            child: Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Text(
                                    'Birthdata:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(height: 5),
                                  InkWell(
                                    onTap: () async {
                                      final date_paker = await showDatePicker(
                                          context: context,
                                          firstDate: DateTime(1960),
                                          initialDate: DateTime.now(),
                                          lastDate: DateTime(2100));
                                      setState(() {
                                        print(date_paker);
                                        // DateTime date = DateTime(date_paker!.year,date_paker!.month,date_paker!.day).toLocal();
                                        // DateTime now = DateTime.now().toLocal();
                                        // now.difference(date).inDays ~/ 365.2425;
                                        // print(now.difference(date).inDays ~/ 365.2425);
                                        Birthdata.text =
                                            DateFormat("yyyy-MM-dd")
                                                .format(date_paker!);
                                      });
                                    },
                                    child: Container(
                                      color: Color(0xFF455A64),
                                      width: 130,
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        Birthdata.text != null
                                            ? Birthdata.text.toString()
                                            : "",
                                        style: TextStyle(fontSize: 16),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 130,
                        height: 80,
                        child: Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Years of experience:',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 5),
                              TextField(
                                controller: experience,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 10,
                                  ),
                                  fillColor: Color(0xFFEEEEEE),
                                  filled: true,
                                  border: InputBorder.none,
                                  hintText: 'Years of experience',
                                  hintStyle: TextStyle(
                                    fontFamily: 'TimesNewRoman',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!Progress) {
                        createAccount(
                            email: Email.text, password: password.text);
                      }
                    },
                    child: Progress == false
                        ? Text(
                            'REGISTER',
                            style: TextStyle(fontSize: 15),
                          )
                        : CircularProgressIndicator(
                            color: Colors.white,
                          ),
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

  void createAccount({required String email, required String password}) async {
    if (Email.text.trim().isNotEmpty &&
        Gender != null &&
        password.isNotEmpty &&
        experience.text.isNotEmpty &&
        Birthdata.text.isNotEmpty) {
      // setState(() {
      //   Progress = true;
      // });
      loadingDialog(context, true);
      Users user = Users.data(
        name: Name.text,
        email: Email.text.trim(),
        type: 'Nanny',
        identityID: Identity_ID.text,
        gender: Gender.toString() == '0' ? "Male" : "Female",
        photoUrl: '',
        fcm: '',
        birthdata: Birthdata.text,
        experience: experience.text,
        isActivate: true,
      );
      bool statusAuth = await FbAuthController()
          .createAccount(context, users: user, password: password);

      if (statusAuth) {
        // setState(() {
        //   Progress = false;
        // });
        loadingDialog(context, false);

        Navigator.pop(context);
      } else {
        showMaterialDialog_login(context, "please try later");
        print('please try later');
      }
    } else {
      showMaterialDialog_login(context, "please enter data correctly");
    }
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
      Navigator.of(context)
        ..pop()
        ..pop();
    }
  }
}
