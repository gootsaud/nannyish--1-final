import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/nanny/send_offer.dart';
import 'package:nannyish/preferences/app_preferences.dart';

class AllUsersAdmin extends StatefulWidget {
  AllUsersAdmin({Key? key}) : super(key: key);

  @override
  State<AllUsersAdmin> createState() => _AllUsersAdminState();
}

class _AllUsersAdminState extends State<AllUsersAdmin> {
  int tab = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[230],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[200],
          title: Text('All Users',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'MeltowSan300',
                fontSize: 23.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
        ),
        body: Container(
          // padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tab = 1;
                          print(tab);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: (tab == 1)
                                ? Colors.grey.shade300
                                : Colors.white,
                            border: Border(
                                bottom: BorderSide(), right: BorderSide())),
                        child: Center(child: Text('Accounts')),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          tab = 2;
                          print(tab);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: (tab == 2)
                                ? Colors.grey.shade300
                                : Colors.white,
                            border: Border(
                                bottom: BorderSide(), left: BorderSide())),
                        child: Center(child: Text('Status')),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                stream: FbFireStoreController().readAll(
                    nameCollection: 'users'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                    List<QueryDocumentSnapshot> allUsersActive = [];
                    List<String> allUsersActiveId = [];
                    List<QueryDocumentSnapshot> allUsers = [];
                    List<String> allUsersId = [];
                    for (var req in data) {
                      if (req.get('isActivate') == true) {
                        allUsersActive.add(req);
                        allUsersActiveId.add(req.id);
                      }
                      allUsers.add(req);
                      allUsersId.add(req.id);

                    }
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        if (tab == 1) {
                          return UserWidget(
                            index: index,
                            tap: 1,
                            name: allUsersActive[index].get('name'),
                            photoUrl: allUsersActive[index].get('photoUrl'),
                            type: allUsersActive[index].get('type'),
                            uid: allUsersActiveId[index],
                            email: allUsersActive[index].get('email'),
                            isActivate: allUsersActive[index].get('isActivate'),
                          );
                        } else {
                          return UserWidget(
                            index: index,
                            tap: 2,
                            name: allUsers[index].get('name'),
                            photoUrl: allUsers[index].get('photoUrl'),
                            type: allUsers[index].get('type'),
                            uid: allUsersId[index],
                            email: allUsers[index].get('email'),
                            isActivate: allUsers[index].get('isActivate'),
                          );
                        }
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: (tab == 1)
                          ? allUsersActive.length
                          : allUsers.length,
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning,
                              size: 85, color: Colors.grey.shade500),
                          Text(
                            'NO Users',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget UserWidget({
    required String name,
    required String photoUrl,
    required String type,
    required String email,
    required String uid,
    required bool isActivate,
    required int tap,
    required int index,
  }) {
    if(email == "admin@gmail.com"){
      return SizedBox();
    }else{
      return Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, bottom: 20),
            child: Container(
              width: 75.0,
              height: 75.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage((photoUrl == '')
                      ? "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png"
                      : photoUrl),
                  fit: BoxFit.fill,
                ),
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(type),
              Text(email),
            ],
          ),
          Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tap==1? ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('users').doc(uid).update({
                          'isActivate':false
                        }).then((value) {
                        });
                      },
                      child: Text(' Deactivate '),
                      style: ElevatedButton.styleFrom(primary: Color(0xFF455A64))):ElevatedButton(
                      onPressed: () async{},
                      child:isActivate?Text(' Activated '): Text(' Deactivated '),
                      style: ElevatedButton.styleFrom(primary: isActivate?Colors.green:Colors.red)),
                ],
              ))
        ],
      );
    }

  }
}
