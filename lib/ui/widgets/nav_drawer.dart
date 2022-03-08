import 'dart:developer';

import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/ui/screens/login_screen.dart';
import 'package:dicegram/ui/screens/prifile._page.dart';
import 'package:dicegram/utils/Color.dart';
import 'package:dicegram/utils/app_constants.dart';
import 'package:dicegram/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.paddingL),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 48, 0, 24),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFFFF1803), Color(0xffFF4A0B)]),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(4, 8), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const Image(
                        image: AssetImage('assets/images/user.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  FutureBuilder<UserModel>(
                    future: UserServices().getUserById(UserServices.userId),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Text(
                          (snapshot.data?.username) != null
                              ? 'Hi ${snapshot.data!.username}'
                              : 'User Name',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors1.primary),
                          maxLines: 1,
                        );
                      } else {
                        return const Text(
                          'User Name',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors1.primary),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const Image(
              image: AssetImage('assets/images/line.png'),
            ),
            ListTile(
              leading: Image.asset('assets/images/profile.png'),
              title: const Text(
                AppConstants.profile,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ))
              },
            ),
            ListTile(
              leading: Image.asset('assets/images/games.png'),
              title: const Text(
                AppConstants.games,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              onTap: () => {},
            ),
            ListTile(
              leading: Image.asset('assets/images/exit.png'),
              title: const Text(
                AppConstants.logOut,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              onTap: () => {
                FirebaseAuth.instance.signOut().then((value) async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                })
              },
            ),
          ],
        ),
      ),
    );
  }
}
