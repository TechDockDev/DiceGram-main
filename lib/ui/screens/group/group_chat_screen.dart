// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/TikTakToe/homePage.dart';
// import 'package:dicegram/chess/chessmain.dart';
import 'package:dicegram/helpers/game_service.dart';
import 'package:dicegram/helpers/group_service.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/group_data.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/snake_ladder/view/snake_ladder.dart';
import 'package:dicegram/ui/screens/dashboard.dart';
import 'package:dicegram/ui/widgets/group/group_chat_bubble.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:dicegram/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../TikTakToe/database.dart';
import '../gamemain.dart';

List<String> selectedUsersList = [];

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({
    Key? key,
    required this.chatId,
    required this.groupName,
    required this.groupData,
  }) : super(key: key);
  final String chatId;
  final String groupName;
  final GroupData groupData;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  bool isShowBox = false;
  bool isGameInitiated = false;
  late GroupData _groupData;
  int selectedGame = -1;

  @override
  void initState() {
    _groupData = widget.groupData;
    if (_groupData.gameId != '') {
      isGameInitiated = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text(widget.groupName),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: height -
                  (MediaQuery.of(context).padding.top + kToolbarHeight),
              child: Column(
                children: [
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: GroupService().getGroupChat(widget.chatId),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              if (snapshot.data?.docs.length == 0) {
                                return const Center(
                                    child: Text('No Messages Here'));
                              } else {
                                return ListView.builder(
                                    reverse: true,
                                    itemCount: snapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      var messageData =
                                          snapshot.data?.docs[index];
                                      var messageId = messageData?.id;
                                      var messageSenderId =
                                          messageData?[KeyConstants.SENDER_ID];
                                      String? messageSenderName = messageData?[
                                          KeyConstants.SENDER_NAME];
                                      var isSeen =
                                          messageData?[KeyConstants.SEEN];
                                      if (isSeen != null &&
                                          isSeen == false &&
                                          (UserServices.userId !=
                                              messageSenderId)) {
                                        UserServices().markMsgRead(
                                            chatId: widget.chatId,
                                            messageId: messageId);
                                      }
                                      return GroupChatBubble(
                                        message:
                                            messageData?[KeyConstants.MESSAGE],
                                        time: getTime(messageData?[
                                            KeyConstants.CREATED_AT]),
                                        isMe: messageData?[
                                                KeyConstants.SENDER_ID] ==
                                            userId,
                                        messageSenderName: messageSenderName,
                                      );
                                    });
                              }
                            } else
                              return SizedBox();
                          })),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors1.textInputBocColor,
                      ),
                      child: TextFormField(
                        obscureText: false,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                            prefixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isShowBox = !isShowBox;
                                  });
                                  if (isShowBox == true) {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  } else {
                                    FocusManager.instance.primaryFocus
                                        ?.nextFocus();
                                  }
                                },
                                icon: Image.asset("assets/images/game.png")),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (textEditingController.text
                                      .trim()
                                      .isNotEmpty) {
                                    GroupService().sendGroupMessage(
                                        message:
                                            textEditingController.text.trim(),
                                        groupId: widget.chatId);
                                    textEditingController.clear();
                                  }
                                },
                                icon: Image.asset("assets/images/send.png")),
                            border: InputBorder.none,
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w200,
                                color: Colors.grey[400])),
                        controller: textEditingController,
                      ),
                    ),
                  ),
                  isShowBox
                      ? Container(
                          height: 50.h,
                          width: double.infinity,
                          child: isGameInitiated
                              ? FutureBuilder<Widget>(
                                  future: getSelectedGame(selectedGame),
                                  builder: (context, data) {
                                    return data.data ?? SizedBox();
                                  },
                                )
                              : Center(
                                child: GridView(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                  children: [
                                    ClipOval(
                                      // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      child: InkWell(
                                        onTap: (){
                                                selectedGame = AppConstants.chess;
                                        onGameSelected(KeyConstants.CHESS);
                                  
                                        },
                                        child: Image.asset('assets/AllGamesPics/ChessSet.jpg', fit: BoxFit.fill,)),
                                    ),
                                    ClipOval(
                                      child: InkWell(
                                        onTap: (){},
                                        
                                        child: Image.asset('assets/AllGamesPics/ludo.png', fit: BoxFit.fill)),
                                    ),
                                    ClipOval(
                                      child: InkWell(
                                        onTap: (){
                                               selectedGame = AppConstants.tikTackToe;
                                        onGameSelected(
                                            KeyConstants.TickTackToe);
                                   
                                   
                                        },
                                        
                                        child: Image.asset('assets/AllGamesPics/tic-tac-toe.jpg', fit: BoxFit.fill)),
                                    ),
                                    ClipOval(
                                      child: InkWell(
                                        onTap: (){
                                          selectedGame = AppConstants.snakeLadder;
                                        onGameSelected(
                                            KeyConstants.SNAKE_LADDER);
                                      
                                        },
                                        child: Image.asset('assets/AllGamesPics/ChessSet.jpg', fit: BoxFit.fill)),
                                    ),

                                  ],
                                  ),
                                  // child: Column(children: [
                                  //   ElevatedButton(
                                  //     onPressed: () {
                                  //       selectedGame = AppConstants.snakeLadder;
                                  //       onGameSelected(
                                  //           KeyConstants.SNAKE_LADDER);
                                  //     },
                                  //     child: Text('Snake Ladder'),
                                  //   ),
                                  //   ElevatedButton(
                                  //     onPressed: () {
                                  //       selectedGame = AppConstants.tikTackToe;
                                  //       onGameSelected(
                                  //           KeyConstants.TickTackToe);
                                  //     },
                                  //     child: Text('Tick Tack Toe'),
                                  //   ),
                                  //   ElevatedButton(
                                  //     onPressed: () {
                                  //       selectedGame = AppConstants.chess;
                                  //       onGameSelected(KeyConstants.CHESS);
                                  //     },
                                  //     child: Text('Chess'),
                                  //   ),
                                  // ]),
                                ))
                      : const SizedBox()
                ],
              ),
            ),
          )),
    );
  }

  void onGameSelected(String selectedGame) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 16,
          child: Container(
            height: 500,
            child: Column(
              children: [
                const Text('Select Players'),
                playersList(users: _groupData.users),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          String gameId = await GameService().createGameRoom(
                              groupId: widget.chatId,
                              userIds: selectedUsersList,
                              game: KeyConstants.SNAKE_LADDER);
                          _groupData.gameId = gameId;
                          _groupData.players = selectedUsersList;
                          _groupData.gameName = KeyConstants.SNAKE_LADDER;
                          setState(() {
                            isGameInitiated = true;
                          });
                        },
                        child: Text('Next')),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Widget> getSelectedGame(int selectedGame) async {
    Widget game = SizedBox();

    switch (selectedGame) {
      case AppConstants.snakeLadder:
        game = SnakeLadder(
          onEnd: () {
            setState(() {
              isGameInitiated = false;
            });
          },
          gameId: _groupData.gameId,
          players: _groupData.players,
          chatId: widget.chatId,
        );
        break;
      case AppConstants.chess:
        game = GameBoardStateLess({"name": 'Chess'}, widget.chatId, this.userId,
            _groupData.players, _groupData.players);
        selectedUsersList = [];
        break;
      case AppConstants.tikTackToe:
        print('asdf : ${selectedUsersList.first}');
        await createChatRoomAndStartConversation(
            userName1: selectedUsersList.first, userName2: userId);
        game = TickTackToe(
          gameRoomId: chatRoomId,
          firstName: firstName,
          currentUser: userId,
          receiver: selectedUsersList.first,
        );
    }

    return game;
  }

  String chatRoomId = '';

  createChatRoomAndStartConversation(
      {String? userName1, String? userName2}) async {
    if (userName1 != userName2) {
      chatRoomId = getChatRoomId(userName1!, userName2!); //!Generate unique id
      List<String> users = [userName1, userName2];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid":
            chatRoomId, //chatroomId needs to be same whenever we are Send Message and Receive Message from the same user
      };
      await DatabaseMethords().createChatRoom(chatRoomId, chatRoomMap);
    } else {
      print("You cannot send message to yourself");
    }
  }

  getChatRoomId(String recieversName, String myName) {
    print(getInitials(recieversName));
    int recieve = getInitials(recieversName).codeUnitAt(0);
    print(getInitials(myName)); // return null

    int my = getInitials(myName).codeUnitAt(0);
    if (my >= recieve) {
      firstName = myName;
      return "$myName\_$recieversName";
    } else
      firstName = recieversName;
    return "$recieversName\_$myName";
  }

  String getInitials(String bank_account_name) => bank_account_name.isNotEmpty
      ? bank_account_name.trim().split(' ').map((l) => l[0]).take(2).join()
      : '';

  String getTime(var time) {
    if (time != null) {
      DateTime dateTime = time.toDate();
      String formatDate = DateFormat("hh:mm").format(dateTime);
      return formatDate;
    }
    return '';
  }
}

class playersList extends StatefulWidget {
  const playersList({Key? key, required this.users}) : super(key: key);
  final List<String> users;

  @override
  State<playersList> createState() => _playersListState();
}

class _playersListState extends State<playersList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
        stream: UserServices().getFirebaseUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data?.docs.length == 0) {
              return const Center(child: Text('No Contacts found'));
            } else {
              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      UserModel users =
                          UserModel.fromSnapshot(snapshot.data?.docs[index]);
                      if (widget.users.contains(users.id) &&
                          UserServices.userId != users.id) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    users.image.toString(),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                          'https://picsum.photos/250?image=9');
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                users.username.toString(),
                                maxLines: 1,
                              )),
                              SizedBox(
                                width: 20,
                                child: Checkbox(
                                  value: selectedUsersList.contains(users.id),
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      print('aaded');
                                      setState(() {
                                        selectedUsersList.add(users.id);
                                      });
                                    } else {
                                      print('aadedr');
                                      setState(() {
                                        selectedUsersList.remove(users.id);
                                      });
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      } else
                        return const SizedBox();
                    }),
              );
            }
          }
          return Text(snapshot.data?.docs.length.toString() ?? '');
        });
  }
}

String firstName = '';
