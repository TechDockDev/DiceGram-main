import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/providers/group_provider.dart';
import 'package:dicegram/ui/screens/new_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chatroom.dart';

class ContactsScreen2 extends StatefulWidget {
  @override
  State<ContactsScreen2> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen2> {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final scafolfkey = GlobalKey<ScaffoldState>();
  List<UserModel> usersList = [];

  @override
  void dispose() {
    GroupProvider().dispose1();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GroupProvider watchprovider = context.watch();
    final GroupProvider readprovider = context.read();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scafolfkey,
      floatingActionButton: FloatingActionButton.small(
        child: const Icon(Icons.arrow_forward),
        onPressed: () {
          if (watchprovider.models.isNotEmpty) {
            List<UserModel> users = [];
            watchprovider.models.forEach((element) {
              usersList.forEach((user) {
                if (user.id == element) {
                  users.add(user);
                }
              });
            });
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewGroupProfile(
                users: users,
              ),
            ));
          } else {
            scafolfkey.currentState!
                .showSnackBar(const SnackBar(content: Text('Invite People')));
          }
        },
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      appBar: AppBar(
        toolbarHeight: 100,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("New Group"),
            Text(
              "Add Participants",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: UserServices().getFirebaseUsers(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              usersList = [];
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
                          UserModel users = UserModel.fromSnapshot(
                              snapshot.data?.docs[index]);
                          print(users.id);
                          usersList.add(users);
                          if (users.id != userId) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.1,
                                    height: width * 0.1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          width * 0.1),
                                      child: Image.network(
                                        users.image.toString(),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.network(
                                              'https://picsum.photos/250?image=9');
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                      width: width * 0.7,
                                      child: Text(
                                        users.username.toString(),
                                        maxLines: 1,
                                      )),
                                  SizedBox(
                                    width: 20,
                                    child: Consumer(
                                      builder: (context, value, child) {
                                        return Checkbox(
                                          value: watchprovider.models
                                              .contains(users.id),
                                          onChanged: (bool? value) {
                                            if (value == true) {
                                              readprovider
                                                  .addList(users.id);
                                            } else {
                                              readprovider.remove(users.id);
                                            }
                                          },
                                        );
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
            }),
      ),
    );
  }

  Future<void> handleOnClick(doc) async {
    String result = await UserServices().getChatroomId(doc);
    if (result == 'notFound') {
      DocumentReference ref =
          await UserServices().createChatRoom([userId, doc]);
      if (ref != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatRooms(
                  roomId: ref.id,
                )));
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatRooms(
                roomId: result,
              )));
    }
  }
}
