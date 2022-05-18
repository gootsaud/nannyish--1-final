import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/firebase/fb_firestore.dart';

class AllReportsAdmin extends StatefulWidget {
  const AllReportsAdmin({Key? key}) : super(key: key);

  @override
  _AllReportsAdminState createState() => _AllReportsAdminState();
}

class _AllReportsAdminState extends State<AllReportsAdmin> {
  int tab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        title: Text('All Report',
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
                          color:
                              (tab == 1) ? Colors.grey.shade300 : Colors.white,
                          border: Border(
                              bottom: BorderSide(), right: BorderSide())),
                      child: Center(child: Text('Parent')),
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
                          color:
                              (tab == 2) ? Colors.grey.shade300 : Colors.white,
                          border:
                              Border(bottom: BorderSide(), left: BorderSide())),
                      child: Center(child: Text('Nanny')),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FbFireStoreController().readAll(nameCollection: 'report'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                  List<QueryDocumentSnapshot> allReportParent = [];
                  List<QueryDocumentSnapshot> allReportNanny = [];
                  for (var req in data) {
                    if (req.get('reportByUserType') == 'Parent') {
                      allReportParent.add(req);
                    } else {
                      allReportNanny.add(req);
                    }
                  }
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      if (tab == 1) {
                        return ListTile(
                          leading: Icon(Icons.album_outlined),
                          title: Text(
                              'Report from Parent Name : ${allReportParent[index].get('reportByUserName')}'),
                          onTap: (){
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.WARNING,
                              animType: AnimType.BOTTOMSLIDE,
                              title: allReportParent[index].get('reportSelectQ'),
                              desc: allReportParent[index].get('reportSelectA'),
                              btnCancelText: 'Done Read',
                              btnCancelOnPress: () {},
                            ).show();
                          },
                        );
                      } else {
                        return ListTile(
                          leading: Icon(Icons.album_outlined),
                          title: Text(
                              'Report from Nanny Name : ${allReportNanny[index].get('reportByUserName')}'),
                          onTap: (){
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.WARNING,
                              animType: AnimType.BOTTOMSLIDE,
                              title: allReportNanny[index].get('reportSelectQ'),
                              desc: allReportNanny[index].get('reportSelectA'),
                              btnCancelText: 'Done Read',
                              btnCancelOnPress: () {},
                            ).show();
                          },
                        );
                      }
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: (tab == 1)
                        ? allReportParent.length
                        : allReportNanny.length,
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning,
                            size: 85, color: Colors.grey.shade500),
                        Text(
                          'NO Report',
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
    );
  }
}
