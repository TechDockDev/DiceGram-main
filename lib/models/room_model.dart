import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';

class Room {
  String imageUrl = '';
  bool isGroup = false;
  String adminId = '';
  List<String> userIds = [];
  String groupName = '';
  Timestamp createdAt = Timestamp.now();

  Room(
      {required this.createdAt,
      required this.imageUrl,
      required this.groupName,
      required this.adminId,
      required this.isGroup,
      required this.userIds});

  Room.fromSnapshot(DocumentSnapshot? snapshot) {
    Map<String, dynamic>? data = snapshot?.data() as Map<String, dynamic>?;
    imageUrl = data?[KeyConstants.IMAGE_URL];
    isGroup = data?[KeyConstants.IS_GROUP];
    adminId = data?[KeyConstants.ADMIN_ID];
    userIds.addAll(data?[KeyConstants.USERS]);
    groupName = data?[KeyConstants.GROUP_NAME];
    createdAt = data?[KeyConstants.CREATED_AT];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> room = {};
    room[KeyConstants.IMAGE_URL] = imageUrl;
    room[KeyConstants.IS_GROUP] = isGroup;
    room[KeyConstants.ADMIN_ID] = adminId;
    room[KeyConstants.USERS] = userIds;
    room[KeyConstants.GROUP_NAME] = groupName;
    room[KeyConstants.CREATED_AT] = createdAt;
    return room;
  }
}
