import 'package:dicegram/utils/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  ChatBubble({required this.message, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width * 0.7,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: isMe ? Colors1.primary : Colors.black12,
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10))
                        : BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                padding: EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(message,
                          style: TextStyle(
                              color: isMe ? Colors.white : Colors.black54,
                              fontSize: 12)),
                    ])),
            Text(time, style: TextStyle(color: Colors.black54, fontSize: 10))
          ],
        ),
      ),
    );
  }
}
