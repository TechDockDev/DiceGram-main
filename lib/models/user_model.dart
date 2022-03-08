import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';

class UserModel {
  String _number = "0";
  String _id = "0";
  Timestamp _createdAt = Timestamp.now();
  String _imageUrl = "";
  bool _online = false;
  Timestamp _lastSeen = Timestamp.now();
  String _username="" ;

//  getters
  String get number => _number;
  String get id => _id;
  Timestamp get createdAt => _createdAt;
  String get image => _imageUrl;
  bool get online => _online;
  Timestamp get lastSeen => _lastSeen;
  String get username => _username;

  UserModel();

  UserModel.fromSnapshot(DocumentSnapshot? snapshot) {
    Map<String, dynamic>? data = snapshot?.data() as Map<String, dynamic>?;
    _number = data?[KeyConstants.NUMBER];
    _id = data?[KeyConstants.ID];
    _createdAt = data?[KeyConstants.CREATED_AT];
    _imageUrl = data?[KeyConstants.IMAGE_URL];
    _online = data?[KeyConstants.ONLINE];
    _lastSeen = data?[KeyConstants.LAST_SEEN];
    _username = data?[KeyConstants.USER_NAME];
  }


}
