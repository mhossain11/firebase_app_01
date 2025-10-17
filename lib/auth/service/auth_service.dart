import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pwa_app_01/cachehelper/chechehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../admin/home/screen/adminhome_screen.dart';
import '../../user/home/screen/home_screen.dart';

class AuthService {
  //Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // FireStore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Register

  Future<String?> signup({
    required String email,
    required String password,
    required String name,
    required String role,
    required String user_id,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
      await _firestore.collection('users').
      doc(userCredential.user!.uid).
      set({
        'name': name.trim(),
        'email': email.trim(),
        'role': role,
        'user_id': user_id.trim(),
      });

      return  userCredential.user!.uid;
    }on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }



  //Sing up

  Future<String?> Login({
    required String email,
    required String password,
  }) async {
    try {
     final userCredential = await _auth
          .signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

     final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

     // ✅ Save user info locally using SharedPreferences
     await CacheHelper().setLoggedIn(userDoc.exists);
     await CacheHelper().setString('isRole',userDoc['role'].toString());
     await CacheHelper().setString('userDocId',userDoc.id.toString());
      print('userDocId:${userDoc.id.toString()}');
     if (userDoc.exists) {
       return userDoc['role'] as String;
     } else {
       return 'User data not found in Firestore.';
     }
    }on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }




}
