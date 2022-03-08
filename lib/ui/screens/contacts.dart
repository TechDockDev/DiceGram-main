import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'chat_screen.dart';
import 'chatroom.dart';

class ContactsScreen extends StatefulWidget {
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    UserModel user = UserModel();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text("Users"),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                Share.share(
                    'hey! check out this new app https://play.google.com/store/apps/details?id=com.dicegram.user.dicegram',
                    subject: 'Dicegram');
              },
              child: Container(
                  color: Colors1.primary,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Invite',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 4.0),
                              blurRadius: 10.0,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: StreamBuilder<QuerySnapshot>(
                stream: UserServices().getFirebaseUsers(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data?.docs.length == 0) {
                      return const Center(child: Text('No Contacts found'));
                    } else {
                      return Container(
                        height: 400,
                        child: Expanded(
                          child: Center(
                            child: ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  user = UserModel.fromSnapshot(
                                      snapshot.data?.docs[index]);
                                  if (user.id != userId) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          UserModel senderData =
                                              UserModel.fromSnapshot(
                                                  snapshot.data?.docs[index]);
                                          await handleOnClick(senderData);
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: width * 0.1,
                                              height: width * 0.1,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width * 0.1),
                                                child: Image.network(
                                                  user.image.toString(),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Image.network(
                                                        'https://picsum.photos/250?image=9');
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            SizedBox(
                                                width: width * 0.7,
                                                child: Text(
                                                  user.username,
                                                  maxLines: 1,
                                                )),
                                            // Checkbox(value: false, onChanged: (bool? value) {  },
                                            // )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else
                                    return SizedBox();
                                }),
                          ),
                        ),
                      );
                    }
                  }
                  return Text(snapshot.data?.docs.length.toString() ?? '');
                }),
          )
        ],
      ),
    );
  }

  Future<void> handleOnClick(UserModel senderData) async {
    String result = await UserServices().getChatroomId(senderData.id);
    if (result == 'notFound') {
      DocumentReference ref =
          await UserServices().createChatRoom([userId, senderData.id]);
      if (ref != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatSccreen(
                  chatId: ref.id,
                  senderName: senderData.username,
                  userModel: senderData,
                )));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatSccreen(
                chatId: result,
                senderName: senderData.username,
                userModel: senderData,
              )));
    }
  }
}
