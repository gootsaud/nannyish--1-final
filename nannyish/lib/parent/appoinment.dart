import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nannyish/chats/chat_screen.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/preferences/app_preferences.dart';
import 'package:nannyish/report/report_screen.dart';

class Appoinment extends StatefulWidget {
  Appoinment({Key? key}) : super(key: key);

  @override
  State<Appoinment> createState() => _AppoinmentState();
}

class _AppoinmentState extends State<Appoinment> {
  String dateOffer = '';
  int tab = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[230],
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[200],
          title: Text('Appointment',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
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
                        child: Center(child: Text('Going')),
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
                        child: Center(child: Text('Previous')),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: FbFireStoreController().read(
                    nameCollection: 'requestFromNanaToParent',
                    orderBy: 'ParentId',
                    descending: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                    List<QueryDocumentSnapshot> myGoingOffers = [];
                    List<String> myGoingOffersId = [];
                    List<QueryDocumentSnapshot> myPrevOffers = [];
                    List<String> myPrevOffersId = [];
                    for (var req in data) {
                      if (req.get('ParentId') ==
                              AppPreferences().getUserData.uid &&
                          req.get('response').isNotEmpty) {
                        if (req.get('response').toString() == "REJECT") {
                          myGoingOffersId.add(req.toString());
                          myPrevOffers.add(req);
                        }
                        else if(int.parse(req.get('response').toString().split("-")[0]) == DateTime.now().year && int.parse(req.get('response').toString().split("-")[1]) == DateTime.now().month && int.parse(req.get('response').toString().split("-")[2]) == DateTime.now().day){
                          print("True");
                          myGoingOffers.add(req);
                        }
                        else if (
                        DateTime.now().isBefore(DateTime(
                            int.parse(
                                req.get('response').toString().split("-")[0]),
                            int.parse(
                                req.get('response').toString().split("-")[1]),
                            int.parse(req
                                .get('response')
                                .toString()
                                .split("-")[2])))
                        ) {
                          myGoingOffersId.add(req.toString());
                          myGoingOffers.add(req);
                        } else {
                          myPrevOffersId.add(req.toString());
                          myPrevOffers.add(req);
                        }
                      }
                    }
                    if (tab == 1) {
                      if (myGoingOffers.isNotEmpty) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return RequestWidget(
                              MakeReport: myPrevOffers[index].get('ParentMakeReport'),
                              ParentId: myGoingOffers[index].get('ParentId'),
                              MakeRate: myGoingOffers[index].get('ParentMakeRate'),
                              from: myGoingOffers[index].get('from'),
                              note: myGoingOffers[index].get('note'),
                              price: myGoingOffers[index].get('price'),
                              name: myGoingOffers[index].get('sendTo'),
                              response: myGoingOffers[index].get('response'),
                              uid: myGoingOffers[index].id,
                              isGoing: true,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: (tab == 1)
                              ? myGoingOffers.length
                              : myPrevOffers.length,
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning,
                                  size: 85, color: Colors.grey.shade500),
                              Text(
                                'NO Appointment',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'TimesNewRoman',
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    } else {
                      if (myPrevOffers.isNotEmpty) {
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return RequestWidget(
                                MakeReport: myPrevOffers[index].get('ParentMakeReport'),
                                ParentId: myPrevOffers[index].get('ParentId'),
                                MakeRate: myPrevOffers[index].get('ParentMakeRate'),
                                from: myPrevOffers[index].get('from'),
                                note: myPrevOffers[index].get('note'),
                                price: myPrevOffers[index].get('price'),
                                name: myPrevOffers[index].get('sendTo'),
                                response: myPrevOffers[index].get('response'),
                                uid: myPrevOffers[index].id,

                                isGoing: false);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: (tab == 1)
                              ? myGoingOffers.length
                              : myPrevOffers.length,
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning,
                                  size: 85, color: Colors.grey.shade500),
                              Text(
                                'NO Appointment',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'TimesNewRoman',
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    }
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning,
                              size: 85, color: Colors.grey.shade500),
                          Text(
                            'NO Appointment',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'TimesNewRoman',
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

  Widget RequestWidget({
    required String name,
    required String ParentId,
    required String from,
    required String note,
    required String response,
    required String uid,
    required bool isGoing,
    required bool MakeRate,
    required bool MakeReport,

    String? price,
  }) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // pickImage();
                      },
                      child: Container(
                        width: 75.0,
                        height: 75.0,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            image: new NetworkImage(
                                "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png"),
                            fit: BoxFit.fill,
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${from}",
                          style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'TimesNewRoman',
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          child: Divider(
                            color: Color.fromARGB(255, 5, 5, 5),
                            thickness: 1,
                          ),
                        ),
                        Container(
                          width: 140,
                          child: Text(
                            'Note :$note',
                            style: TextStyle(
                              fontFamily: 'TimesNewRoman',
                            ),
                          ),
                        ),
                        Text(
                          'Offered :$price',
                          style: TextStyle(
                            fontFamily: 'TimesNewRoman',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (isGoing && response != "REJECT")
                      ? ElevatedButton(
                          onPressed: () async {
                            bool state = await FbFireStoreController().checkExists(collection: 'chat',doc: uid);
                            print(state);
                            if(!state){
                              bool state = await FbFireStoreController().createChatCollection(nameDoc: uid);
                              print(state);
                              if(state){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(path: uid,)));
                              }
                            }else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(path: uid,)));
                            }
                          },
                          child:  isGoing
                                  ? Text('   Chat   ')
                                  : SizedBox(),
                          style: ElevatedButton.styleFrom(
                              primary:  Colors.pinkAccent))
                      : SizedBox(),
                  (isGoing || response == "REJECT")
                      ? ElevatedButton(
                      onPressed: () async {
                        if (response != 'REJECT') {
                          isGoing ? AlertDialogWidget(uid: uid) : () {};
                        } else {
                          print('REJECT');
                        }
                      },
                      child: (response == 'REJECT')
                          ? Text('REJECT')
                          : isGoing
                          ? Text(' Cancel ')
                          : SizedBox(),
                      style: ElevatedButton.styleFrom(
                          primary: (response == 'REJECT')
                              ? Colors.grey
                              : Colors.green))
                      : SizedBox(),
                ],
              ),

            ),
            Padding(
              padding: EdgeInsets.only(right: 48.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!isGoing &&!MakeReport && response != 'REJECT')
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportScreen(path: uid,nameUpdate: 'ParentMakeReport',)));
                        },
                        child:
                        Text('Report'),
                        style: ElevatedButton.styleFrom(
                            primary:  Colors.redAccent)),
                  if (response != 'REJECT' && !isGoing && !MakeRate)
                    ElevatedButton(
                        onPressed: () async {
                          return AwesomeDialog(
                            context: context,
                            animType: AnimType.LEFTSLIDE,
                            body: RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                FirebaseFirestore.instance.collection("requestFromNanaToParent").doc(uid).update({
                                  "NannyRate":rating,
                                  "ParentMakeRate":true,
                                }).then((value) {
                                  Navigator.pop(context);
                                });
                              },
                            )
                          ).show();
                        },
                        child: Text('  Rate  '),
                        style: ElevatedButton.styleFrom(
                            primary: (response == 'REJECT')
                                ? Colors.grey
                                : Colors.green))
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ديلوج يظهر عند الضغط على الموافقة أو الرفض
  AlertDialogWidget({required String uid}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Cancel',
          ),
          content: Text(
            'You are canceling the appointment\nAre you sure?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                bool state = await FbFireStoreController().updateState(
                    collectionName: 'requestFromNanaToParent',
                    data: {'response': 'REJECT'},
                    uid: uid);
                if (state) {
                  print('success REJECT REQUEST');
                  Navigator.pop(context);
                } else {
                  print('try later');
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        );
      },
    );
  }
}
