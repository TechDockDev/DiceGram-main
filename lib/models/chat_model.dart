import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';

class ChatModel {
  String _senderId = "0";
  String _id = "0";
  Timestamp _createdAt = Timestamp.now();
  String _imageUrl = "";
  bool _online = false;
  Timestamp _lastMessageTime = Timestamp.now();
  String _username="" ;
  String _lastMessage="" ;

//  getters
  String get senderId => _senderId;
  String get id => _id;
  Timestamp get createdAt => _createdAt;
  String get image => _imageUrl;
  bool get online => _online;
  Timestamp get lastMessageTime => _lastMessageTime;
  String get username => _username;
   String get lastMessage =>_lastMessage ;

  ChatModel();

  ChatModel.fromSnapshot(DocumentSnapshot? snapshot) {
    Map<String, dynamic>? data = snapshot?.data() as Map<String, dynamic>?;
    _senderId = data?[KeyConstants.SENDER_ID];
    _id = data?[KeyConstants.ID];
    _createdAt = data?[KeyConstants.CREATED_AT];
    _imageUrl = data?[KeyConstants.IMAGE_URL];
    _online = data?[KeyConstants.ONLINE];
    _lastMessage = data?[KeyConstants.LAST_MESSAGE];
    _lastMessageTime = data?[KeyConstants.LAST_MESSAGE_TIME];
    _username = data?[KeyConstants.USER_NAME];
  }
}
