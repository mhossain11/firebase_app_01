import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pwa_app_01/cachehelper/chechehelper.dart';
import 'package:flutter/material.dart';

import '../../../auth/screen/login_screen.dart';
import '../../userlist/screen/userlist_screen.dart';
import '../service/adminhome_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   AdminHomeService _adminHomeService = AdminHomeService();
  int _userCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserCount();
  }


  Future<void> loadUserCount() async {
    try {
      int totalUsers = await _adminHomeService.getTotalUserCount();

      if (!mounted) return; // ✅ Prevent setState after dispose
      setState(() {
        _userCount = totalUsers;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading user count: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    print('CountUser1:$_userCount');
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),

        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications)),
          PopupMenuButton<int>(
              onSelected: (item)=>onSelected(item,context),
              itemBuilder: (context)=>[
            PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(Icons.login),
                        SizedBox(width: 10,),
                        Text('Logout'),
                      ],
                    )),
            const PopupMenuDivider(),
            PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10,),
                        Text('Setting'),
                      ],
                    )),

          ]
          ),
        ],
      ),
      
      body: Column(
        children: [
          //Total Member
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Card(
              elevation: 5,
              child: Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_userCount.toString(),style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                    Text('Total Members',style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                    ),),
                  ],
                ),
              ),
            ),
          ),
          //Total Amount
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Card(
              elevation: 5,
              child: Container(
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('20000 Tk',style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                    Text('Total Amount',style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700
                    ),),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              // button
              GestureDetector(
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              //list button
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>UserListScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade300,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset('assets/images/userlist.png',
                              color: Colors.white,
                              width: 80,
                              height: 50,),
                          ),
                        SizedBox(height: 5,),
                        Text('User List',style: TextStyle(
                            fontSize: 16,color: Colors.white
                        ),)
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
          
        ],
      ),
    );
  }

  void onSelected(int item, BuildContext context) async{
    switch (item){
      case 0:
       await _auth.signOut();
        CacheHelper().clear();
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>LoginScreen()));
        break;
    }

  }
}
