import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/group_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/ui/widgets/group/group_chat_row.dart';
import 'package:flutter/material.dart';

class GroupChatCard extends StatelessWidget {

  final String groupId;
  const GroupChatCard({
    required this.groupId,
  }) : super();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String username;
    String imageUrl;
    bool isOnline;
    return StreamBuilder<DocumentSnapshot>(
      stream: GroupService().getGroupStreamByGroupId(groupId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        var groupData = snapshot.data;

        if (snapshot.data == null) {
          return const Text('User not Found');
        }
        username = groupData?[KeyConstants.GROUP_NAME];
        isOnline = true;
        imageUrl = groupData?[KeyConstants.IMAGE_URL];

        return GroupChatRow(
            width: width,
            imageUrl: imageUrl,
            isOnline: isOnline,
            username: username,
            groupId: groupId);
      },
    );
  }
}
