import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/parent/request.dart';
import 'package:nannyish/parent/view_offers.dart';
import 'package:rate_in_stars/rate_in_stars.dart';

class list extends StatefulWidget {
  list({Key? key}) : super(key: key);

  @override
  State<list> createState() => _listState();
}

class _listState extends State<list> {
  bool searchState = false;
  String textSearch = '';
  String searchFor = '2';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF455A64),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SendRequest(
                          nameReciver: 'all',
                          fcm: '',
                        )));
          },
          child: Icon(Icons.send),
        ),
        backgroundColor: Colors.grey[230],
        appBar: AppBar(
          // actions: [
          //   !searchState
          //       ? IconButton(
          //     onPressed: () {
          //       setState(() {
          //         searchState = !searchState;
          //       });
          //     },
          //     icon: const Icon(Icons.search),
          //     color: Color(0xFF455A64),
          //   )
          //       : IconButton(
          //     onPressed: () {
          //       setState(() {
          //         searchState = !searchState;
          //       });
          //     },
          //     icon: const Icon(Icons.cancel),
          //     color: Color(0xFF455A64),
          //   ),
          // ],
          backgroundColor: Colors.grey[200],
          title:
              // !searchState
              //     ? Text('  Nannies list  ',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontFamily: 'TimesNewRoman',
              //       fontSize: 23.0,
              //       fontWeight: FontWeight.normal,
              //       color: Colors.black,
              //     ))
              //     :
              Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'search',
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  onChanged: (text) {
                    setState(() {
                      textSearch = text;
                    });
                    // SearchMethod(text: text);
                  },
                ),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    // border: Border.all(),
                    // borderRadius: BorderRadius.circular(3)
                    ),
                child: DropdownButtonFormField(
                    isDense: true,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                    hint: const DropdownMenuItem(
                      child: Text(
                        'select',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onChanged: (s) {
                      setState(() {
                        searchFor = s.toString();
                        print(s);
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
                      const DropdownMenuItem(
                        value: 0,
                        child: Text('Name'),
                      ),
                      const DropdownMenuItem(
                        value: 1,
                        child: Text('Experience'),
                      ),
                    ]),
              ))
            ],
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FbFireStoreController().read(
                  nameCollection: 'users', orderBy: 'type', descending: true),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                  List<QueryDocumentSnapshot> onlyNannyList = [];
                  List<String> onlyNannyListId = [];
                  for (var nannies in data) {
                    if (nannies.get('type') == 'Nanny') {
                      onlyNannyList.add(nannies);
                      onlyNannyListId.add(nannies.id);
                    }
                  }
                  List<QueryDocumentSnapshot> listWithSearch =
                      searchMethod(onlyNannyList: onlyNannyList);
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return NannyWidget(
                          id: onlyNannyListId[index],
                          name: listWithSearch[index].get('name'),
                          experience: listWithSearch[index].get('experience'),
                          fcm: listWithSearch[index].get('fcm'),
                          nameReciver: listWithSearch[index].id);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: listWithSearch.length,
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning,
                            size: 85, color: Colors.grey.shade500),
                        Text(
                          'NO NANNIES',
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
      ),
    );
  }

  Widget NannyWidget(
      {required String name,
      required String id,
      required String fcm,
      required String experience,
      required String nameReciver}) {
    num sum = 1;
    num average = 1;


    // if(id == AppPreferences().getUserData.uid){
    //   averageRate = averageRate + req.get('ParentRate');
    //   sum++;
    // }
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 75.0,
          height: 75.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                width: 200,
                child: Divider(
                  color: Colors.black,
                  thickness: 1,
                ),
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
                      if(req.get('nanyId') == id  ){
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
                width: 200,
                height: 20,
                child: Divider(
                  color: Color.fromARGB(255, 67, 73, 68),
                  thickness: 2,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF455A64)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendRequest(
                                  nameReciver: nameReciver,
                                  fcm: fcm,
                                )));
                  },
                  child: Text(
                    'Request',
                    style: TextStyle(
                      fontFamily: 'TimesNewRoman',
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }

  List<QueryDocumentSnapshot> searchMethod(
      {required List<QueryDocumentSnapshot> onlyNannyList}) {
    List<QueryDocumentSnapshot> data = [];
    if (textSearch.isEmpty) {
      data = onlyNannyList;
    } else {
      if (searchFor == '0') {
        for (var item in onlyNannyList) {
          if (item.get('name').toLowerCase().contains(textSearch)) {
            data.add(item);
          }
        }
      } else if (searchFor == '1') {
        for (var item in onlyNannyList) {
          if (item.get('experience').toLowerCase().contains(textSearch)) {
            data.add(item);
          }
        }
      } else {
        data = [];
      }
    }

    return data;
  }
}
