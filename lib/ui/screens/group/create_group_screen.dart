import 'dart:developer';

import 'package:dicegram/helpers/group_service.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/ui/screens/group/group_chat_screen.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatelessWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> userList = [
      'jCy7qWLyU9VaABkmCqazISJirm72',
      'Ol3Lk3cx0jRQEUxRfkJXmcYN2c53'
    ];
    return Scaffold(
      body: Center(
        child: Container(
          child: TextButton(
            child: const Text('Create Group'),
            onPressed: () async {
              // GroupService()
              //     .createGroup(
              //         adminId: UserServices.userId,
              //         userIds: userList,
              //         groupName: 'adasda',
              //         imageUrl: '')
              //     .then((value) {
              //   // Navigator.of(context).push(MaterialPageRoute(
              //   //     builder: (context) => GroupChatScreen(
              //   //
              //   //           chatId: value.id,
              //   //           groupName: 'groupNam',
              //   //         )));
              // }).onError((error, stackTrace) {
              //   log(error.toString());
              // });
            },
          ),
        ),
      ),
    );
  }
}
