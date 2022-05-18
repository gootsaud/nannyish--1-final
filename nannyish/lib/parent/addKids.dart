import 'package:flutter/material.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/main.dart';
import 'package:nannyish/preferences/app_preferences.dart';

class AddKidsScreen extends StatefulWidget {
  AddKidsScreen({Key? key}) : super(key: key);

  @override
  State<AddKidsScreen> createState() => _AddKidsScreenState();
}

class _AddKidsScreenState extends State<AddKidsScreen> {
  TextEditingController name = new TextEditingController();
  TextEditingController age = new TextEditingController();
  TextEditingController note = new TextEditingController();

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
                          width: 260,
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          'Rating: 3.4/5',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.zero),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: new Icon(Icons.cancel)),
                      Flexible(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Center(child: Text('Name'))),
                                    Expanded(
                                      flex: 4,
                                      child: TextField(
                                        controller: name,
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
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Center(child: Text('Age'))),
                                    Expanded(
                                      flex: 4,
                                      child: TextField(
                                        controller: age,
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
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Center(child: Text('Notes'))),
                                    Expanded(
                                      flex: 4,
                                      child: TextField(
                                        controller: note,
                                        maxLines: 5,
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
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (name.text.isNotEmpty &&
                                        age.text.isNotEmpty &&
                                        note.text.isNotEmpty) {
                                      runAddKids();
                                    } else {
                                      showMaterialDialog_login(context,
                                          "please enter data correctly");
                                    }
                                  },
                                  child: const Text('ADD'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18),
                                    elevation: 0,
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'MeltowSan300',
                                    ),
                                    primary: Color(0xFF455A64),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero)),
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
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void runAddKids() async {
    List<dynamic> kidList = <dynamic>[];
    String kidsString = 'Name:${name.text}/Age:${age.text}/Notes:${note.text}';
    kidList.add(kidsString);
    bool state = await FbFireStoreController().updateArray(
        nameDoc: AppPreferences().getUserData.uid.toString(), data: kidList);

    if (state) {
      Navigator.pop(context);
    } else {
      showMaterialDialog_login(context, "Try Again");
    }
  }
}
