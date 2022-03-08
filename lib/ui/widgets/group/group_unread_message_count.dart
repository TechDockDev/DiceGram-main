import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/group_service.dart';
import 'package:flutter/material.dart';

class GroupUnreadMessageCount extends StatelessWidget {

  final String groupId;

  const GroupUnreadMessageCount({
    required this.groupId,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: GroupService().getGroupUnreadMessageCount(groupId),
        builder: (context, snapshot) {
          var unreadMessageCount = snapshot.data?.docs.length;
          if (unreadMessageCount == null) {
            return const SizedBox();
          }

          return unreadMessageCount > 0
              ? Container(
                  height: 23,
                  width: 23,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      unreadMessageCount < 10
                          ? unreadMessageCount.toString()
                          : '9+',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
              : const SizedBox();
        });
  }
}
