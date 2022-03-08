import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethords {
  getUserByUsername(String username) async {
    //!     in user collection, skips docoments, 
    //!     searches for name (in 2nd collection).
    //todo  but from where does it store users from Authenticate? 
    //      in DatabaseMethords uploadUserInfo
    
    return await FirebaseFirestore.instance
        .collection('users')
        .where("name", isEqualTo: username)
        .get(); 
        
        // Query statement
    // gives QuerySnapshot as value
    //doesnt download any data, but sends query to database
    //getdocoments() is changed to get()
    //docoment() changed to doc()
    //setData() changed to set()
  }

  getUserByUserEmail(String useremail) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: useremail)
        .get(); // Query statement
  }

  uploadUserInfo(userMap) {
    //! Upload data to FireBase
    //Data stored in Database is a Map. Map has key value pair.
    //Convert to Map before uploading.
        //! Map is 'name': ...., 'email': ....
    //See signUp screen for same
    FirebaseFirestore.instance.collection('users').add(userMap).catchError((e) {
      print(e.toString());
    });
  } //Also can write .Docoment... insted of .add If you have added your own docoment id in Firestore

  createChatRoom(String chatRoomId, chatRoomMap) async {
    //? USED IN SEARCH.DART
    //In this case we define the docomentname
    //set() recieves Map
    //? ChatRoom => username_username2 => chatroomid, users: username,username2
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

//? Used in ConversationScreen (getConversationMessage and addConversationMessage)
  getConversationMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  addConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChatRoom(String userName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots(); //We use Snapshot instead of get() bcoz we want it Realtime
  }
}
