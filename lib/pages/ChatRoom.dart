import 'dart:io';

import 'package:bat_cheet/Components/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ChatRoom extends StatelessWidget {
  ChatRoom({super.key, required this.userMap, required this.chatRoomId});
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  final _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

// on tap send the mesage to the person
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> message = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "time": FieldValue.serverTimestamp()
      };

      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(message);

      _message.clear();
    } else {
      print("Enter some text");
    }
  }

  //image pick and send to the user
  File? imageFile;

  Future getImage() async {
    final _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        uploadImage(imageFile);
      }
    });
  }

  Future uploadImage(File? imageFile) async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    // ignore: body_might_complete_normally_catch_error
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: StreamBuilder<DocumentSnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(userMap['uid'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Container(
                      child: Column(
                        children: [
                          Text(userMap['name']),
                          Text(snapshot.data!['status'])
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                })),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: size.height / 1.25,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('chatroom')
                          .doc(chatRoomId)
                          .collection('chats')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;
                                return messages(size, map, context);
                              });
                        } else {
                          return Container();
                        }
                      })),
              Container(
                height: size.height / 10,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height / 17,
                        width: size.width / 1.3,
                        child: TextField(
                          controller: _message,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  getImage();
                                },
                                icon: Icon(
                                  Icons.photo,
                                  color: Colors.deepPurple[400],
                                ),
                              ),
                              hintText: "Send Message",
                              fillColor: kPrimaryColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send), onPressed: onSendMessage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    // return map['type'] == "img"
    return Container(
        width: size.width,
        alignment: map['sendby'] == _auth.currentUser!.displayName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: map['sendby'] == _auth.currentUser!.displayName
                ? Colors.deepPurple[300]
                : Colors.black87,
          ),
          child: Text(
            map['message'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ));
    // : Container(
    //     height: size.height / 2.5,
    //     width: size.width,
    //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //     alignment: map['sendby'] == _auth.currentUser!.displayName
    //         ? Alignment.centerRight
    //         : Alignment.centerLeft,
    //     child: InkWell(
    //       onTap: () => Navigator.of(context).push(
    //         MaterialPageRoute(
    //           builder: (_) => ShowImage(
    //             imageUrl: map['message'],
    //           ),
    //         ),
    //       ),
    //       child: Container(
    //         height: size.height / 2.5,
    //         width: size.width / 2,
    //         decoration: BoxDecoration(border: Border.all()),
    //         alignment: map['message'] != "" ? null : Alignment.center,
    //         child: map['message'] != ""
    //             ? Image.network(
    //                 map['message'],
    //                 fit: BoxFit.cover,
    //               )
    //             : CircularProgressIndicator(),
    //       ),
    //     ),
    //   );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
