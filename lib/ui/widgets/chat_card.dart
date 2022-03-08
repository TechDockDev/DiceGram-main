import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String lastMessage;
  final int numberOfMsg;
  final bool isOnline;
  final String date;

  const ChatCard({
    required this.name,
    required this.imageUrl,
    required this.lastMessage,
    required this.numberOfMsg,
    required this.isOnline,
    required this.date,
  }) : super();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width * 0.16,
            height: width * 0.16,
            child: Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network('https://picsum.photos/250?image=9');
                  },
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Icon(
                  Icons.circle,
                  color: isOnline ? Colors.green : Colors.red,
                ),
              )
            ]),
          ),
          SizedBox(
            width: width * 0.04,
          ),
          SizedBox(
            height: width * 0.16,
            width: width * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                ),
                Text(
                  lastMessage,
                  maxLines: 1,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: width * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(color: Colors.black45),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  numberOfMsg > 0
                      ? Container(
                          height: 23,
                          width: 23,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              numberOfMsg < 10 ? numberOfMsg.toString() : '9+',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))
                      : SizedBox()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
