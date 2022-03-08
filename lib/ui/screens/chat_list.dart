
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/ui/widgets/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chatroom.dart';

class ChatList extends StatefulWidget{
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: StreamBuilder<QuerySnapshot>(
          stream: UserServices().getChatList(),
          builder: (context , snapshot){
            if(!snapshot.hasData || snapshot.data?.docs.length==0){
              return const SizedBox();
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatRooms(roomId: snapshot.data?.docs[index].id.toString()??''))),
                    child:  ChatCard(
                        name: snapshot.data?.docs[index].id.toString()??'',
                        imageUrl: snapshot.data?.docs[index][KeyConstants.IMAGE_URL],
                        lastMessage: 'last Message',
                        numberOfMsg: 0,
                        isOnline: true,
                        date: getTime(snapshot.data?.docs[index][KeyConstants.CREATED_AT]),
                    ),
                  );
                });
          }),
    );
  }

  String getTime(var time) {
    if(time!=null){
      DateTime dateTime = time.toDate();
      String formatDate =  DateFormat("hh:mm").format(dateTime);
      return formatDate;
    }
    return '';
  }
}



