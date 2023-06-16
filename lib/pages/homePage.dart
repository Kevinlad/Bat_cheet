import 'package:bat_cheet/pages/ChatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../group_chat/group_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _search = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
// status offline or online of an user Widget Binding obser is required

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("online");
  }

  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //Online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  bool isLoading = false;
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeScreen'),
        backgroundColor: Color(0XFF6A62B7),
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.width / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  width: size.width / 1.3,
                  height: size.height / 14,
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Color(0XFF6A62B7),
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    controller: _search,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    onSearch();
                  },
                  style: ElevatedButton.styleFrom(primary: Color(0XFF6A62B7)),
                  child: Text("Search"),
                ),
                userMap != null
                    ? ListTile(
                        hoverColor: Colors.deepPurple[300],
                        onTap: () {
                          String roomId = chatRoomId(
                              _auth.currentUser!.displayName!,
                              userMap!['name']);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatRoom(
                                chatRoomId: roomId,
                                userMap: userMap!,
                              ),
                            ),
                          );
                        },
                        leading: Icon(Icons.account_box, color: Colors.black),
                        title: Text(
                          userMap!['name'],
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          userMap!['email'],
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(
                          Icons.chat,
                          color: Colors.black,
                        ),
                      )
                    : Container()
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0XFF6A62B7),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GroupChatScreen()));
        },
        child: Icon(Icons.group),
      ),
    );
  }
}
