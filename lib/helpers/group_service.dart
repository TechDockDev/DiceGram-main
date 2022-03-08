import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/models/room_model.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupService {
  Future<DocumentReference> createGroup(
      {required GroupData groupData}) async {
    DocumentReference docRef = await FirebaseUtils.getGroupListColRef().add(
        groupData
            .toMap());
    return docRef;
  }

  Stream<DocumentSnapshot> getGroupStreamByGroupId(groupId) {
    return FirebaseUtils.getGroupListColRef().doc(groupId).snapshots();
  }

  Stream<QuerySnapshot> getGroupUnreadMessageCount(groupId) {
    var v = FirebaseUtils.getGroupListColRef()
        .doc(groupId)
        .collection(KeyConstants.MESSAGE)
        .where(KeyConstants.SENDER_ID, isNotEqualTo: UserServices.userId)
        .where(KeyConstants.SEEN, isEqualTo: false)
        .snapshots();
    return v;
  }

  Stream<QuerySnapshot> getChat(groupId) => FirebaseUtils.getGroupListColRef()
      .doc(groupId)
      .collection(KeyConstants.MESSAGE)
      .orderBy(KeyConstants.CREATED_AT, descending: true)
      .snapshots();

  Stream<QuerySnapshot> getGroupChat(groupId) =>
      FirebaseUtils.getGroupListColRef()
          .doc(groupId)
          .collection(KeyConstants.MESSAGE)
          .orderBy(KeyConstants.CREATED_AT, descending: true)
          .snapshots();

  void sendGroupMessage(
      {required String message, required String groupId}) async {
    Map<String, dynamic> data = {};

    if (UserServices.userId.isNotEmpty) {
      //
      UserModel user = await UserServices().getUserById(UserServices.userId);

      data[KeyConstants.SENDER_ID] = UserServices.userId;
      data[KeyConstants.CREATED_AT] = FieldValue.serverTimestamp();
      data[KeyConstants.MESSAGE_TYPE] = 'text';
      data[KeyConstants.MESSAGE] = message;
      data[KeyConstants.SEEN] = false;
      data[KeyConstants.SENDER_NAME] = user.username;
      FirebaseUtils.getGroupListColRef()
          .doc(groupId)
          .collection(KeyConstants.MESSAGE)
          .add(data);
    }
  }

  Stream<QuerySnapshot> getGroupList() {
    var v = FirebaseUtils.getGroupListColRef()
        .where(KeyConstants.USERS_ARRAY_IN_CHAT,
            arrayContains: UserServices.userId)
        .snapshots();
    return v;
  }

  Stream<QuerySnapshot> getGroupLastMessage(groupId) {
    var v = FirebaseUtils.getGroupListColRef()
        .doc(groupId)
        .collection(KeyConstants.MESSAGE)
        .orderBy(KeyConstants.CREATED_AT)
        .limitToLast(1)
        .snapshots();
    return v;
  }

  Future<void> markGroupMsgRead({required chatId, required messageId}) async {
    await FirebaseUtils.getGroupListColRef()
        .doc(chatId)
        .collection(KeyConstants.MESSAGE)
        .doc(messageId)
        .update({KeyConstants.SEEN: true}).catchError((onError) {});
  }
}
