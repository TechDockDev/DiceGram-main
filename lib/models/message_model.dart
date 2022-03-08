import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';

class MessageModel {
  String _senderId = "0";
  String _createdAt = FieldValue.serverTimestamp().toString();
 // String _senderName = "";
  bool _read = false;
  String _msgType = "text";
 // String _msgId = 'id';
  String _message = '';

//  getters
  String get senderId => _senderId;
  String get createdAt => _createdAt;
 // String get senderName => _senderName;
  bool get read => _read;
  String get messageType => _msgType;
 // String get messageId => _msgId;
  String get message => _message;


  MessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    _senderId = data?[KeyConstants.SENDER_ID];
    _createdAt = data?[KeyConstants.CREATED_AT];
    _read = data?[KeyConstants.SEEN];
    _msgType = data?[KeyConstants.MESSAGE_TYPE];
    // _senderName = data?[KeyConstants.SENDER_ID];
     //_msgId = data?[KeyConstants.ID];
     _message = data?[KeyConstants.MESSAGE];
  }
}
