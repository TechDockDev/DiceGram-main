import 'package:cloud_firestore/cloud_firestore.dart';

class GroupData {
  String adminId ='';
  Timestamp createdAt =Timestamp.now();
  String groupName ='';
  String imageUrl='';
  bool isGroup=true;
  List<String> players=[];
  String gameName = '';
  String gameId = '';
  List<String> users =[];

  GroupData(
      { required this.adminId ,
        required this.createdAt,
        required this.groupName,
        required this.imageUrl,
        required this.isGroup,
        required this.players,
        required this.gameName,
        required this.gameId,
        required this.users});

  GroupData.fromSnapshot(DocumentSnapshot? snapshot) {
    Map<String, dynamic>? json = snapshot?.data() as Map<String, dynamic>?;
    adminId = json?['adminId'];
    createdAt = json?['createdAt'];
    groupName = json?['groupName'];
    imageUrl = json?['imageUrl'];
    isGroup = json?['isGroup'];
    players = json?['players'].cast<String>();
    gameName = json?['gameName'];
    gameId = json?['gameId'];
    users = json?['users'].cast<String>();
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['adminId'] = adminId;
    data['createdAt'] = createdAt;
    data['groupName'] = groupName;
    data['imageUrl'] = imageUrl;
    data['isGroup'] = isGroup;
    data['players'] = players;
    data['gameName'] = gameName;
    data['gameId'] = gameId;
    data['users'] = users;
    return data;
  }
}