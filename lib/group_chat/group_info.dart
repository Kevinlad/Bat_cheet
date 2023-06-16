// import 'package:bat_cheet/group_chat/addmember_ingroup.dart';
// import 'package:bat_cheet/pages/homePage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';

// class GroupInfo extends StatefulWidget {
//   const GroupInfo({super.key, required this.groupName, required this.groupId});
//   final String groupName, groupId;
//   @override
//   State<GroupInfo> createState() => _GroupInfoState();
// }

// class _GroupInfoState extends State<GroupInfo> {
//   bool isLoading = true;
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List memberList = [];
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getGroupDetails();
//   }

//   Future getGroupDetails() async {
//     await _firestore
//         .collection('groups')
//         .doc(widget.groupId)
//         .get()
//         .then((chatMap) {
//       memberList = chatMap['member'];
//       print(memberList);
//       isLoading = false;
//       setState(() {});
//     });
//   }

//   void showRemoveDialog(int index) {
//     showDialog(
//         context: context,
//         builder: (_) {
//           return AlertDialog(
//             content: ListTile(
//               onTap: () {
//                 removeUser(index);
//               },
//               title: Text('Remove ${memberList[index]['name']}'),
//             ),
//           );
//         });
//   }

//   bool checkAdmin() {
//     bool isAdmin = false;
//     memberList.forEach((element) {
//       if (element['uid'] == _auth.currentUser!.uid) {
//         isAdmin = element['isAdmin'];
//       }
//     });
//     return isAdmin;
//   }

//   void onLeaveGroup() async {
//     if (!checkAdmin()) {
//       setState(() {
//         isLoading = true;
//       });
//       String uid = _auth.currentUser!.uid;
//       for (int i = 0; i < memberList.length; i++) {
//         if (memberList[i]['uid'] == uid) {
//           memberList.removeAt(i);
//         }
//       }
//       await _firestore
//           .collection('groups')
//           .doc(widget.groupId)
//           .update({"member": memberList});
//       await _firestore
//           .collection('users')
//           .doc(uid)
//           .collection('groups')
//           .doc(widget.groupId)
//           .delete();

//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
//     } else {
//       print('Cant leave group');
//     }
//   }

//   void removeUser(int index) async {
//     if (checkAdmin()) {
//       if (_auth.currentUser!.uid == memberList[index]['uid']) {
//         setState(() {
//           isLoading = true;
//         });
//         memberList.removeAt(index);
//         String uid = memberList[index]['uid'];
//         await _firestore
//             .collection('groups')
//             .doc(widget.groupId)
//             .update({"member": memberList});

//         await _firestore
//             .collection('users')
//             .doc(uid)
//             .collection('groups')
//             .doc(widget.groupId)
//             .delete();
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         body: isLoading
//             ? Container(
//                 height: size.height,
//                 width: size.width,
//                 alignment: Alignment.center,
//                 child: CircularProgressIndicator())
//             : SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: BackButton(),
//                     ),
//                     Container(
//                       height: size.height / 8,
//                       width: size.width / 1.1,
//                       child: Row(
//                         children: [
//                           Container(
//                             height: size.height / 11,
//                             width: size.height / 11,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.grey,
//                             ),
//                             child: Icon(
//                               Icons.group,
//                               color: Colors.white,
//                               size: size.width / 10,
//                             ),
//                           ),
//                           SizedBox(
//                             width: size.width / 20,
//                           ),
//                           Expanded(
//                             child: Container(
//                               child: Text(
//                                 widget.groupName,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: size.width / 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     //

//                     SizedBox(
//                       height: size.height / 20,
//                     ),

//                     Container(
//                       width: size.width / 1.1,
//                       child: Text(
//                         " ${memberList.length} Member",
//                         style: TextStyle(
//                           fontSize: size.width / 20,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),

//                     SizedBox(
//                       height: size.height / 20,
//                     ),

//                     // Members Name
//                     checkAdmin()
//                         ? ListTile(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: ((context) => AddMembersINGroup(
//                                           name: widget.groupId,
//                                           membersList: memberList,
//                                           groupChatId: widget.groupId))));
//                             },
//                             leading: Icon(
//                               Icons.add,
//                             ),
//                             title: Text(
//                               "Add Members",
//                               style: TextStyle(
//                                 fontSize: size.width / 22,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           )
//                         : SizedBox(),

//                     Flexible(
//                       child: ListView.builder(
//                         itemCount: memberList.length,
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             onTap: () => showRemoveDialog(index),
//                             leading: Icon(Icons.account_circle),
//                             title: Text(
//                               memberList[index]['name'],
//                               style: TextStyle(
//                                 fontSize: size.width / 22,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             subtitle: Text(memberList[index]['email']),
//                             trailing: Text(
//                                 memberList[index]['isAdmin'] ? "Admin" : ""),
//                           );
//                         },
//                       ),
//                     ),

//                     ListTile(
//                       onTap: () {},
//                       leading: Icon(
//                         Icons.logout,
//                         color: Colors.redAccent,
//                       ),
//                       title: Text(
//                         "Leave Group",
//                         style: TextStyle(
//                           fontSize: size.width / 22,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/homePage.dart';
import 'addmember_ingroup.dart';

class GroupInfo extends StatefulWidget {
  final String groupId, groupName;
  const GroupInfo({required this.groupId, required this.groupName, Key? key})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  List membersList = [];
  bool isLoading = true;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupDetails();
  }

  Future getGroupDetails() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((value) {
      membersList = value['member'];
      isLoading = false;
      setState(() {});
    });
  }

  bool checkAdmin() {
    bool isAdmin = false;

    membersList.forEach((element) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  Future removeMembers(int index) async {
    String uid = membersList[index]['uid'];

    setState(() {
      isLoading = true;
      membersList.removeAt(index);
    });

    await _firestore.collection('groups').doc(widget.groupId).update({
      "member": membersList,
    }).then((value) async {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      setState(() {
        isLoading = false;
      });
    });
  }

  void showDialogBox(int index) {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != membersList[index]['uid']) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: ListTile(
                  onTap: () => removeMembers(index),
                  title: Text("Remove This Member"),
                ),
              );
            });
      }
    }
  }

  Future onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });

      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == _auth.currentUser!.uid) {
          membersList.removeAt(i);
        }
      }

      await _firestore.collection('groups').doc(widget.groupId).update({
        "member": membersList,
      });

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Container(
                height: size.height,
                width: size.width,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(),
                    ),
                    Container(
                      height: size.height / 8,
                      width: size.width / 1.1,
                      child: Row(
                        children: [
                          Container(
                            height: size.height / 11,
                            width: size.height / 11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.group,
                              color: Colors.white,
                              size: size.width / 10,
                            ),
                          ),
                          SizedBox(
                            width: size.width / 20,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.groupName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: size.width / 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //

                    SizedBox(
                      height: size.height / 20,
                    ),

                    Container(
                      width: size.width / 1.1,
                      child: Text(
                        "${membersList.length} Members",
                        style: TextStyle(
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: size.height / 20,
                    ),

                    // Members Name

                    checkAdmin()
                        ? ListTile(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AddMembersINGroup(
                                  groupChatId: widget.groupId,
                                  name: widget.groupName,
                                  membersList: membersList,
                                ),
                              ),
                            ),
                            leading: Icon(
                              Icons.add,
                            ),
                            title: Text(
                              "Add Members",
                              style: TextStyle(
                                fontSize: size.width / 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        : SizedBox(),

                    Flexible(
                      child: ListView.builder(
                        itemCount: membersList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => showDialogBox(index),
                            leading: Icon(Icons.account_circle),
                            title: Text(
                              membersList[index]['name'],
                              style: TextStyle(
                                fontSize: size.width / 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(membersList[index]['email']),
                            trailing: Text(
                                membersList[index]['isAdmin'] ? "Admin" : ""),
                          );
                        },
                      ),
                    ),

                    ListTile(
                      onTap: onLeaveGroup,
                      leading: Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        "Leave Group",
                        style: TextStyle(
                          fontSize: size.width / 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
