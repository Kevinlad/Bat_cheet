import 'package:bat_cheet/Components/constant.dart';
import 'package:bat_cheet/group_chat/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddMember extends StatefulWidget {
  AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _search = TextEditingController();
  bool isLoading = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> memberList = [];
  Map<String, dynamic>? userMap;
  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    // this to sezrch the user id from the database

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data(); //  by giving user id map  in database

        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentDetails();
  }

  void getCurrentDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        memberList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "isAdmin": true,
        });
      });
    });
  }

  void onResultTap() async {
    bool isAlredyExist = false;
    for (int i = 0; i < memberList.length; i++) {
      if (memberList[i]['uid'] == userMap?['uid']) {
        isAlredyExist = true;
      }
    }
    if (!isAlredyExist) {
      setState(() {
        memberList.add({
          "name": userMap!['name'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false
        });
        userMap = null;
      });
    }
  }

  // to remove from add member
  void onRemoveMember(int index) async {
    if (memberList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        memberList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: ListView.builder(
                    itemCount: memberList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          onRemoveMember(index);
                        },
                        leading: Icon(Icons.account_circle),
                        title: Text(memberList[index]['name']),
                        subtitle: Text(memberList[index]['email']),
                        trailing: Icon(Icons.close),
                      );
                    })),
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
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
            isLoading
                ? Container(
                    height: size.height / 12,
                    width: size.height / 12,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    onPressed: () {
                      onSearch();
                    },
                    style: ElevatedButton.styleFrom(primary: kPrimaryColor),
                    child: Text("Search"),
                  ),
            userMap != null
                ? ListTile(
                    onTap: () {
                      onResultTap();
                    },
                    leading: Icon(Icons.account_box),
                    title: Text(userMap!['name']),
                    subtitle: Text(userMap!['email']),
                    trailing: Icon(Icons.add),
                  )
                : SizedBox(),
          ],
        ),
      ),
      floatingActionButton: memberList.length >= 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateGroup(
                              memberList: memberList,
                            )));
              },
              child: Icon(Icons.forward),
            )
          : SizedBox(),
    );
  }
}
