import 'package:bat_cheet/pages/Sigup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: body_might_complete_normally_nullable
Future<User?> createAccount(
    String email, String username, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    user!.updateDisplayName(username);
    // ignore: unnecessary_null_comparison
    if (user != null) {
      print("Account created successfully");
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": username,
        "email": email,
        "status": "unaviable",
        "uid": _auth.currentUser!.uid
      });
    } else {
      print("Account does not created");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> login(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("login successfully");
      return user;
    } else {
      print("Login Failed");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignUpPage()));
    });
  } catch (e) {
    print('error');
  }
}
