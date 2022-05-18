import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/nanny/send_offer.dart';
import 'package:nannyish/preferences/app_preferences.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class ListRequests extends StatefulWidget {
  ListRequests({Key? key}) : super(key: key);

  @override
  State<ListRequests> createState() => _ListRequestsState();
}

class _ListRequestsState extends State<ListRequests> {
  int tab = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[230],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[200],
          title: Text('Requests',
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
                        child: Center(child: Text('General')),
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
                        child: Center(child: Text('Private')),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: FbFireStoreController().read(
                    nameCollection: 'request',
                    orderBy: 'sendTo',
                    descending: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                    List<QueryDocumentSnapshot> generalRequest = [];
                    List<QueryDocumentSnapshot> privateRequest = [];
                    for (var req in data) {
                      if (req.get('sendTo') == 'all') {
                        generalRequest.add(req);
                      } else if (req.get('sendTo') ==
                          AppPreferences().getUserData.uid!) {
                        privateRequest.add(req);
                      }
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        if (tab == 1) {
                          return RequestWidget(
                              IdFrom:generalRequest[index].get('IdFrom'),
                              name: generalRequest[index].get('from'),
                              date: generalRequest[index].get('date'),
                              time: generalRequest[index].get('time'),
                              kids: generalRequest[index].get('kidsName'),
                              isPrivate: false);
                        } else {
                          return RequestWidget(
                              name: privateRequest[index].get('from'),
                              IdFrom: privateRequest[index].get('IdFrom'),
                              date: privateRequest[index].get('date'),
                              time: privateRequest[index].get('time'),
                              kids: privateRequest[index].get('kidsName'),
                              isPrivate: true);
                        }
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: (tab == 1)
                          ? generalRequest.length
                          : privateRequest.length,
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning,
                              size: 85, color: Colors.grey.shade500),
                          Text(
                            'NO Requests',
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

  Widget RequestWidget(
      {required String name,
        required String IdFrom,
        required String date,
      required String time,
      required List<dynamic> kids,
      required bool isPrivate}) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$name'),
                Divider(
                  indent: 1,
                  thickness: 2,
                  endIndent: 100,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FbFireStoreController().readAll(
                      nameCollection: 'requestFromNanaToParent'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      num averageRate = 0;
                      List<QueryDocumentSnapshot> data =
                          snapshot.data!.docs;
                      int sum = 0;
                      for (var req in data) {
                        if(req.get('ParentId') == IdFrom ){
                          averageRate = averageRate + req.get('ParentRate');
                          sum++;
                        }
                      }
                      return RatingStars(
                        editable: false,
                        rating: averageRate/sum,
                        color: Colors.amber,
                        iconSize: 25,
                      );
                    } else {
                      return Text("No Rates Yet");
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Date : $date'),
                Text('Time :$time'),
                Text('Kids :'),
                ListView.builder(
                  itemCount: kids.length,
                  itemBuilder: (context, index) {
                    return Text(kids[index]);
                  },
                  shrinkWrap: true,
                ),
              ],
            ),
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SendOffer(IdFrom,name,date,time,kids)));

                },
                child: Text(' OFFER '),
                style: ElevatedButton.styleFrom(primary: Color(0xFF455A64))),
            Visibility(
              visible: isPrivate,
              child: ElevatedButton(
                  onPressed: () {},
                  child: Text('REJECT'),
                  style: ElevatedButton.styleFrom(primary: Colors.red)),
            ),
          ],
        ))
      ],
    );
  }
}
