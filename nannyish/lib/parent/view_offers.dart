import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/nanny/send_offer.dart';
import 'package:nannyish/parent/payment.dart';
import 'package:nannyish/preferences/app_preferences.dart';

class ViewOffers extends StatefulWidget {
  ViewOffers({Key? key}) : super(key: key);

  @override
  State<ViewOffers> createState() => _ViewOffersState();
}

class _ViewOffersState extends State<ViewOffers> {
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
          title: Text('Offers',
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
                        for (var req in data) {
                          if (req.get('ParentId') ==
                              AppPreferences().getUserData.uid && req.get('response').isEmpty) {
                            myOffers.add(req);
                          }
                        }
                        if(myOffers.isNotEmpty){
                          return ListView.separated(
                            itemBuilder: (context, index) {
                              return RequestWidget(
                                ParentId: myOffers[index].get('ParentId'),
                                from: myOffers[index].get('from'),
                                note: myOffers[index].get('note'),
                                price: myOffers[index].get('price'),
                                name: myOffers[index].get('sendTo'),
                                response: myOffers[index].get('response'),
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
                        } else{
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
    required String ParentId,
    required String from,
    required String note,
    required String response,
    required String uid,
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
        Padding(
          padding: EdgeInsets.only(right: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (response.isEmpty) {
                      bool state = await dateWidget();
                      if (state) {
                        print(dateOffer);
                        AlertDialogWidget(
                            from: 1, uid: uid, price: price ?? '0');
                      } else {}
                    } else {
                      print('disable');
                    }
                  },
                  child: Text('    Accept    '),
                  style: ElevatedButton.styleFrom(primary: Colors.green)),
              SizedBox(height: 5),
              ElevatedButton(
                  onPressed: () {
                    if (response.isEmpty) {
                      AlertDialogWidget(from: 2, uid: uid, price: price ?? '0');
                    }
                  },
                  child: Text('     Reject    '),
                  style: ElevatedButton.styleFrom(primary: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  /// ديلوج يظهر عند الضغط على الموافقة أو الرفض
  AlertDialogWidget(
      {required int from, required String uid, required String price}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            (from == 1) ? 'Accept' : 'REJECT',
          ),
          content: (from == 1)
              ? Text(
            'Offer will be sent\nThe date chosen is $dateOffer',
            textAlign: TextAlign.center,
          )
              : Text(
            'Do you really want to REJECT the request?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (from == 1) {
                  bool state = await FbFireStoreController().updateState(
                      collectionName: 'requestFromNanaToParent',
                      data: {'response': dateOffer},
                      uid: uid);
                  if (state) {
                    print('success Add OFFER REQUEST');
                    Navigator.pop(context);
                    /// التحويل لصفحة الدفع في حال الموافقة
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Payment(int.parse(price))));
                  } else {
                    print('try later');
                    Navigator.pop(context);
                  }
                } else {
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

  /// فنكشن اظهار اختيار التاريخ في حال تقديم عرض (اكسبت)
  Future<bool> dateWidget() async {
    final date_paker = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialDate: DateTime.now(),
        lastDate: DateTime(2100));
    dateOffer = DateFormat("yyyy-MM-dd").format(date_paker!);

    if (dateOffer.isNotEmpty) {
      return true;
    } else {
      return false;
    }
    // });
  }
}
