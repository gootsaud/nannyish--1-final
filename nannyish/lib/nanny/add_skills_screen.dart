import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/nanny/nav_n.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/main.dart';
import 'package:nannyish/preferences/app_preferences.dart';

/*****/
class AddSkillsScreen extends StatefulWidget {
  AddSkillsScreen({Key? key}) : super(key: key);

  @override
  State<AddSkillsScreen> createState() => _AddSkillsScreenState();
}

class _AddSkillsScreenState extends State<AddSkillsScreen> {
  TextEditingController skills = new TextEditingController();

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
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text('Add Skills'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Center(child: Text('Skill:'))),
                                    Expanded(
                                      flex: 4,
                                      child: TextField(
                                        controller: skills,
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
                                    if (skills.text.isNotEmpty) {
                                      runAddSkills();
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

  void runAddSkills() async {
    List<dynamic> skillsList = <dynamic>[];
    String kidsString = skills.text;
    skillsList.add(kidsString);

    bool state = await FbFireStoreController().updateArraySkills(
        nameDoc: AppPreferences().getUserData.uid.toString(), data: skillsList);

    if (state) {
      List<String> newList = [];
      List old = AppPreferences().getUserData.skills!;
      newList.add(kidsString);
      for (String list in old) {
        newList.add(list.toString());
      }
      await AppPreferences().saveAndChangeSkills(list: newList);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => nav_n()));
      // Navigator.pop(context);
    } else {
      showMaterialDialog_login(context, "Try Again");
    }
  }
}
