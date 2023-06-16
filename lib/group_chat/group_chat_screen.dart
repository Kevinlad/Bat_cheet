import 'package:bat_cheet/Components/constant.dart';
import 'package:bat_cheet/group_chat/add_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'group_chat_room.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isLoading = true;
  List groupList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAviableGroups();
  }

  void getAviableGroups() async {
    String uid = _auth.currentUser!.uid;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get()
        .then((value) {
      setState(() {
        groupList = value.docs;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        backgroundColor: kPrimaryColor,
      ),
      body: ListView.builder(
          itemCount: groupList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupChatRoom(
                              groupName: groupList[index]['name'],
                              groupChatId: groupList[index]['id'],
                            )));
              },
              leading: Icon(Icons.group),
              title: Text(groupList[index]['name']),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMember()));
        },
        child: Icon(Icons.create),
        tooltip: "Create Group ",
      ),
    );
  }
}
