import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/ui/widgets/one_to_one/chat_bubble.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRooms extends StatefulWidget {
  const ChatRooms({Key? key, required this.roomId}) : super(key: key);
  final String roomId;

  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  final _messageFocusNode = FocusNode();
  String uderId = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    print('asdf  - ${widget.roomId}');
    TextEditingController textEditingController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(widget.roomId),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: UserServices().getChat(widget.roomId),
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
                                  return ChatBubble(
                                      message: snapshot.data?.docs[index]
                                          [KeyConstants.MESSAGE],
                                      time: getTime(snapshot.data?.docs[index]
                                          [KeyConstants.CREATED_AT]),
                                      isMe: snapshot.data?.docs[index]
                                              [KeyConstants.SENDER_ID] ==
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
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blueAccent.withOpacity(0.3),
                  ),
                  child: TextFormField(
                    focusNode: _messageFocusNode,
                    obscureText: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.gamepad)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (textEditingController.text
                                  .trim()
                                  .isNotEmpty) {
                                UserServices().sendMessage(
                                    message: textEditingController.text.trim(),
                                    roomId: widget.roomId);
                                textEditingController.clear();
                              }
                            },
                            icon: const Icon(Icons.send)),
                        border: InputBorder.none,
                        hintText: '....',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey[400])),
                    controller: textEditingController,
                  ),
                ),
              ),
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
