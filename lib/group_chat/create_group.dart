import 'package:bat_cheet/Components/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../pages/homePage.dart';

class CreateGroup extends StatefulWidget {
  CreateGroup({Key? key, required this.memberList}) : super(key: key);
  final List<Map<String, dynamic>> memberList;
  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
//  final List<Map<String, dynamic>> membersList;
  void createGroup() async {
    setState(() {
      isLoading = true;
    });
    String groupId = Uuid().v1();
    await _firestore
        .collection('groups')
        .doc('groupId')
        .set({"member": widget.memberList, "id": groupId});

    for (int i = 0; i < widget.memberList.length; i++) {
      String uid = widget.memberList[i]['uid'];
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({"name": _groupName.text, "id": groupId});

      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
          .add({
        "message": "${_auth.currentUser!.displayName} Created this group",
        "type": "notify"
      });
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Group Name"),
        backgroundColor: kPrimaryColor,
      ),
      body: isLoading
          ? Container(
              height: size.height,
              width: size.width,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _groupName,
                      decoration: InputDecoration(
                        hintText: "Enter Group Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: () {
                    createGroup();
                  },
                  child: Text("Create Group"),
                ),
              ],
            ),
    );
  }
}
