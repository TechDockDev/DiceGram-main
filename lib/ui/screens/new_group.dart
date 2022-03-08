import 'dart:developer';

import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/providers/group_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'group/group_chat_screen.dart';

class NewGroupProfile extends StatefulWidget {
  static const Color bagroundColor = Color(0xffFA3E0E);
  final List<UserModel> users;

  NewGroupProfile({Key? key, required this.users}) : super(key: key);

  @override
  State<NewGroupProfile> createState() => _NewGroupProfileState();
}

class _NewGroupProfileState extends State<NewGroupProfile> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'Lable');
  final focusl = FocusNode();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final GroupProvider watchprovider = context.watch();
    final GroupProvider readprovider = context.read();
    return Form(
      key: _formKey,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.small(
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              readprovider.updateGroupName(controller.text);
              readprovider.createGroup(widget.users, context);
            }
          },
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        body: Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration:
                      const BoxDecoration(color: NewGroupProfile.bagroundColor),
                )),
            Positioned(
              top: 50,
              left: 5,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            const Positioned(
              top: 65,
              left: 55,
              child: Text(
                'New Group',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Positioned(
                top: 125,
                left: 115,
                child: SizedBox(
                  height: 100,
                  width: 110,
                  child: watchprovider.imageprofile != null
                      ? Image.file(
                          watchprovider.imageprofile!,
                          fit: BoxFit.fitHeight,
                          // alignment: FractionalOffset.topCenter,
                        )
                      : Container(
                          height: 110,
                          width: 110,
                          color: Colors.grey[300],
                        ),
                )),
            Positioned(
                top: 205,
                right: 135,
                child: GestureDetector(
                    onTap: () async {
                      readprovider.handleURLButtonPress(
                        context,
                      );
                    },
                    child: Image.asset('assets/images/camera.png'))),
            Positioned(
              left: 0,
              right: 0,
              top: 160,
              child: Column(
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38.withOpacity(0.2),
                              blurRadius: 2,
                              spreadRadius: 2)
                        ],
                        color: const Color(0xffE7EBF0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: TextFormField(
                          focusNode: focusl,
                          validator: (value) {
                            if (value!.length <= 3) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Add valid Group name')));
                            } else {
                            }
                          },
                          controller: controller,
                          decoration: InputDecoration(
                              label: Text(watchprovider.groupName),
                              contentPadding: const EdgeInsets.only(left: 20),
                              border: InputBorder.none)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 310,
                left: 15,
                child: Text(
                  'Players : ${widget.users.length}',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
            Positioned(
                top: 300,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 400,
                  child: ListView.builder(
                      itemCount: widget.users.length,
                      itemBuilder: (context, index) {
                        final data = widget.users[index];
                        print(data.id);
                        // usersList.add(users);
                        // if (users.id != userId)
                        {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width * 0.1,
                                    height: width * 0.1,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.1),
                                      child: Image.network(
                                        data.image.toString(),
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
                                        data.username.toString(),
                                        maxLines: 1,
                                      )),
                                ],
                              ),
                            ),
                          );
                        }
                        // else
                        //   return const SizedBox();
                      }),
                ))
          ],
        ),
      ),
    );
  }
}
