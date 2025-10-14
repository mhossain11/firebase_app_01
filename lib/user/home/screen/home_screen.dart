import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../auth/screen/login_screen.dart';
import '../../../cachehelper/chechehelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
            FirebaseAuth.instance.signOut();
            CacheHelper().clear();
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context)=>LoginScreen()));
          }, icon: Icon(Icons.login))
        ],
      ),
    );
  }
}
