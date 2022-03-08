import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/ui/screens/chat_screen.dart';
import 'package:dicegram/ui/screens/chatroom.dart';
import 'package:dicegram/ui/widgets/one_to_one/chat_card1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList2 extends StatefulWidget {
  const ChatList2({Key? key}) : super(key: key);

  @override
  State<ChatList2> createState() => _ChatList2State();
}

class _ChatList2State extends State<ChatList2> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: UserServices().getChatList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
            return const SizedBox();
          }

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var chatId = snapshot.data?.docs[index].id;

                String? senderId = (snapshot.data?.docs[index]['users'][0] ==
                        FirebaseAuth.instance.currentUser!.uid)
                    ? snapshot.data?.docs[index]['users'][1]
                    : snapshot.data?.docs[index]['users'][0];

                return ChatCard1(
                  userId: senderId.toString(),
                  chatId: chatId.toString(),
                );
              });
        });
  }

  String getTime(var time) {
    if (time != null) {
      DateTime dateTime = time.toDate();
      String formatDate = DateFormat("hh:mm").format(dateTime);
      return formatDate;
    }
    return '';
  }
}
