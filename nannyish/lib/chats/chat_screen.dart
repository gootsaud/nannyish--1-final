import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:nannyish/chats/loading.dart';
import 'package:nannyish/chats/no_data_chat.dart';
import 'package:nannyish/firebase/fb_firestore.dart';
import 'package:nannyish/preferences/app_preferences.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({required this.path});

  late var path;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textChatController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textChatController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textChatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(FirebaseAuth.instance.currentUser != null){
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey[200],
          title: Text('Chat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'TimesNewRoman',
                fontSize: 23.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              )),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  // stream: ChatDB().getChats(widget.isLawyer),
                  stream: FbFireStoreController().readChat(
                      doc: widget.path, orderBy: 'time', descending: true),
                  builder: (context, snapshot) {
                    debugPrint('context, snapshot');
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      debugPrint('waiting');
                      return Loading();
                    } else if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      List<QueryDocumentSnapshot> chats = snapshot.data!.docs;
                      debugPrint("here chat size ${chats.length}");
                      return Column(
                        children: [
                          // Expanded(child: Container()),
                          Container(height: 5,),
                          Flexible(
                            child: ListView.separated(
                              physics: ScrollPhysics(),
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection:  Axis.vertical,
                              itemBuilder: (context, index) {
                                print(chats[index]['body']);
                                return (AppPreferences().getUserData.uid ==
                                        chats[index]['sendBy'])
                                    ? Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15, vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius.circular(10)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          chats[index]['body'],
                                                          style: TextStyle(
                                                              color: Colors.black),
                                                        ),
                                                        Container(
                                                          transform:
                                                              Matrix4.translationValues(
                                                                  5, 5, 0),
                                                          child: Text(
                                                            '${chats[index]['hour']}:${chats[index]['minute']}',
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 9),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                              ))
                                        ],
                                      )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                              )),
                                          Expanded(
                                            flex:2,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 15, vertical: 10),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                        BorderRadius.circular(10)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          chats[index]['body'],
                                                          style: TextStyle(
                                                              color: Colors.black),
                                                        ),
                                                        Container(
                                                          transform:
                                                          Matrix4.translationValues(
                                                              5, 5, 0),
                                                          child: Text(
                                                            '${chats[index]['hour']}:${chats[index]['minute']}',
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 9),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 3,
                                );
                              },
                              itemCount: chats.length,
                              // reverse: true,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    } else {
                      debugPrint('NoDataChat');
                      return Container();
                    }
                  }),
            ),
            Container(
              height: 50,
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: textChatController,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFEEEEEE),
                          filled: true,
                          border: InputBorder.none,
                          hintText: 'Write Here',
                          hintStyle: TextStyle(
                            fontFamily: 'TimesNewRoman',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (textChatController.text.trim().isNotEmpty) {
                          String text = textChatController.text;
                          textChatController.clear();
                          bool state = await FbFireStoreController()
                              .sendChat(doc: widget.path, data: {
                            'body': text,
                            'sendBy': AppPreferences().getUserData.uid,
                            'time': DateTime.now().microsecondsSinceEpoch,
                            'hour': DateTime.now().hour,
                            'minute': DateTime.now().minute,
                          });
                          if (state) {}
                        }
                      },
                      icon: Icon(Icons.send))
                ],
              ),
            )
          ],
        ));
  }
}
