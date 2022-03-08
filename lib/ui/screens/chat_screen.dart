import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/ui/widgets/one_to_one/chat_bubble.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatSccreen extends StatefulWidget {
  const ChatSccreen(
      {Key? key,
      required this.chatId,
      required this.senderName,
      required this.userModel})
      : super(key: key);
  final String chatId;
  final String senderName;
  final UserModel userModel;

  @override
  State<ChatSccreen> createState() => _ChatSccreenState();

}

class _ChatSccreenState extends State<ChatSccreen> {
  String uderId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool isShowBox = false;
  final FocusNode _focusnode = FocusNode();

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.senderName),
            StreamBuilder<QuerySnapshot>(
              stream: UserServices().getUserStreamByUserId(widget.userModel.id),
              builder: (context, snapshot) {
                if (snapshot.data == null || !snapshot.hasData) {
                  return const SizedBox();
                }
                bool isOnline = snapshot.data?.docs[0][KeyConstants.ONLINE];
                return isOnline
                    ? const Text('Online', style: TextStyle(fontSize: 10))
                    : const Text('Offline', style: TextStyle(fontSize: 10));
              },
            ),
          ]),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  flex: 9,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: UserServices().getChat(widget.chatId),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          if (snapshot.data?.docs.length == 0) {
                            return const Center(
                                child: Text('No Messages Here'));
                          } else {
                            return ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  var messageData = snapshot.data?.docs[index];
                                  var messageId = messageData?.id;
                                  var messageSenderId =
                                      messageData?[KeyConstants.SENDER_ID];
                                  var isSeen = messageData?[KeyConstants.SEEN];
                                  if (isSeen != null &&
                                      isSeen == false &&
                                      (UserServices.userId !=
                                          messageSenderId)) {
                                    UserServices().markMsgRead(
                                        chatId: widget.chatId,
                                        messageId: messageId);
                                  }
                                  return ChatBubble(
                                      message:
                                          messageData?[KeyConstants.MESSAGE],
                                      time: getTime(messageData?[
                                          KeyConstants.CREATED_AT]),
                                      isMe: messageData?[
                                              KeyConstants.SENDER_ID] ==
                                          uderId);
                                });
                          }
                        } else {
                          return const SizedBox();
                        }
                      })),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors1.textInputBocColor,
                  ),
                  child: TextFormField(
                    focusNode: _focusnode,
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isShowBox = !isShowBox;
                              });
                              if (isShowBox == true) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              } else {
                                FocusManager.instance.primaryFocus?.nextFocus();
                              }
                            },
                            icon: Image.asset("assets/images/game.png")),
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (textEditingController.text
                                  .trim()
                                  .isNotEmpty) {
                                UserServices().sendMessage(
                                    message: textEditingController.text.trim(),
                                    roomId: widget.chatId);
                                textEditingController.clear();
                              }
                            },
                            icon: Image.asset("assets/images/send.png")),
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey[400])),
                    controller: textEditingController,
                  ),
                ),
              ),
              isShowBox
                  ? Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.black,
                    )
                  : const SizedBox()
            ],
          ),
        ));
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
