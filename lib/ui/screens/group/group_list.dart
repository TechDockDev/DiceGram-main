import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/group_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:dicegram/ui/widgets/group/group_chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: GroupService().getGroupList(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.docs.length == 0) {
            return const SizedBox();
          }

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var chatId = snapshot.data?.docs[index].id;

                String? groupName =
                    snapshot.data?.docs[index][KeyConstants.GROUP_NAME];
                GroupData groupData = GroupData.fromSnapshot(snapshot.data?.docs[index]);
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GroupChatScreen(
                          groupData: groupData,
                              chatId: chatId ?? "",
                              groupName: groupName.toString(),
                            )));
                  },
                  child: GroupChatCard(
                    groupId: chatId.toString(),
                  ),
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
