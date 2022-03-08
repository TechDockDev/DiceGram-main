import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dicegram/helpers/key_constants.dart';
import 'package:dicegram/helpers/user_service.dart';
import 'package:dicegram/models/user_model.dart';
import 'package:dicegram/utils/firebase_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
//fireabse
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestoreCloud = FirebaseFirestore.instance;
  final String collectionname = 'profileimage';
  final String docname = 'user1';
//
  static const Color buttoncolor = Color(0xffFF7043);
  final imagePicker = ImagePicker();
  File? imageprofile;
  String? username;

  void handleURLButtonPress(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          XFile? image = await imagePicker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 50,
                              preferredCameraDevice: CameraDevice.front);
                          if (image != null) {
                            _cropImage(image.path, context);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Pick From Camera')),

                    TextButton(
                        onPressed: () async {
                          XFile? image = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50,
                          );
                          if (image != null) {
                            _cropImage(image.path, context);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Pick From Gallery'))
                    // : const Text('Pick From Gallery')),
                  ],
                )
              ],
            ));
  }

  void _cropImage(filePath, BuildContext context) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      // maxWidth: 1080,
      // maxHeight: 1080,
    );
    if (croppedImage != null) {
      imageprofile = croppedImage;
      uploadPic(imageprofile!);
      notifyListeners();

      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
    }
  }
  //!firebase upload

  Future<String> uploadPic(File imagefi) async {
    final reference = _storage.ref().child("images/");
    final UploadTask uploadTask = reference.putFile(imagefi);
    final TaskSnapshot location = uploadTask.snapshot;
    final String url = await location.ref.getDownloadURL();

    print(url);
    uploadToCLoudstorege(url);
    return url;
  }

  Future<UserModel> getCurrentUserModel() =>
      FirebaseUtils.getUsersColRef().doc(UserServices.userId).get().then((doc) {
        return UserModel.fromSnapshot(doc);
      });

//
  Future uploadToCLoudstorege(String url) async {
    await _firestoreCloud
        .collection(KeyConstants.USERS)
        .doc(UserServices.userId)
        .update({KeyConstants.IMAGE_URL: url});
  }

  //Edit BUtton
  void handleEditButton(
    BuildContext context,
    TextEditingController controller,
  ) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 50,
          backgroundColor: Colors.transparent,
          actions: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          border: InputBorder.none)),
                ),
                Positioned(
                  top: 0,
                  left: 200,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      username = controller.text.trim();
                      UserServices().updateCurrentUserData(
                          {KeyConstants.USER_NAME: username});
                      notifyListeners();
                      Navigator.of(context).pop();
                    },
                    child: Center(
                      child: MediaQuery.removePadding(
                        context: context,
                        child: Container(
                          height: 54,
                          width: 66,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: buttoncolor,
                          ),
                          child: const Center(
                              child: Text(
                            'Save',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
