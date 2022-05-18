import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/nanny/edit_offer.dart';
import 'package:nannyish/nanny/send_offer.dart';
import 'package:nannyish/parent/payment.dart';
import 'package:nannyish/preferences/app_preferences.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class MyOffer extends StatefulWidget {
  MyOffer({Key? key}) : super(key: key);

  @override
  State<MyOffer> createState() => _MyOfferState();
}

class _MyOfferState extends State<MyOffer> {
  String dateOffer = '';

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
          title: Text('Offers awaiting response',
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
                    List<QueryDocumentSnapshot> myOffers = [];
                    List<String> myOffersId = [];
                    for (var req in data) {
                      if (req.get('nanyId') ==
                              AppPreferences().getUserData.uid &&
                          req.get('response').isEmpty) {
                        myOffers.add(req);
                      }
                    }
                    if (myOffers.isNotEmpty) {
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return RequestWidget(
                            name: myOffers[index].get('sendTo'),
                            id: myOffers[index].get('ParentId'),
                            note: myOffers[index].get('note'),
                            price: myOffers[index].get('price'),
                            time: myOffers[index].get('time'),
                            date: myOffers[index].get('date'),
                            countKids:
                                myOffers[index].get('countKids').toString(),
                            uid: myOffers[index].id,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemCount: myOffers.length,
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning,
                                size: 85, color: Colors.grey.shade500),
                            Text(
                              'NO Offers',
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
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning,
                              size: 85, color: Colors.grey.shade500),
                          Text(
                            'NO Offers',
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
    required String note,
    required String id,
    required String price,
    required String uid,
    required String time,
    required String date,
    required String countKids,
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
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "parent name :${name}",
                            style: TextStyle(
                              fontSize: 15,
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
                              'My Note :$note',
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditOffer(
                                  date: date,
                                  uid: uid,
                                  kids: countKids,
                                  name: name,
                                  note: note,
                                  price: price,
                                  time: time,
                                )));
                  },
                  child: Text('  Edit Offer  '),
                  style: ElevatedButton.styleFrom(primary: Colors.green)),
              SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () {
                    AlertDialogWidget(uid: uid);
                  },
                  child: Text('Delete Offer'),
                  style: ElevatedButton.styleFrom(primary: Colors.red)),
            ],
          ),
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
            'Delete Offer',
          ),
          content: Text(
            'You are Delete Offer \nare you sure?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                bool state = await FbFireStoreController().deleteState(
                    collectionName: 'requestFromNanaToParent', uid: uid);
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
