import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pwa_app_01/admin/note/screen/note_screen.dart';
import 'package:firebase_pwa_app_01/cachehelper/chechehelper.dart';
import 'package:flutter/material.dart';

import '../../../auth/screen/login_screen.dart';
import '../../moneydelete/screen/moneydelete_screen.dart';
import '../../save_money/screen/saving_money_screen.dart';
import '../../userlist/screen/userlist_screen.dart';
import '../service/adminhome_service.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
   final AdminHomeService _adminHomeService = AdminHomeService();
  bool _isLoading = true;
  int userTotal =0;
  int adminTotal =0;

  @override
  void initState(){
    super.initState();
    countTota();
  }

  void countTota() async{
    userTotal= await loadUserCount('user');
    adminTotal= await loadUserCount('admin');
  }


  Future<int> loadUserCount(String role) async {
    try {
      int totalUsers = await _adminHomeService.getTotalUserCount(role);

      if (!mounted) return 0; // ✅ Widget dispose হয়ে গেলে return করো

      setState(() {
        _isLoading = false;
      });

      return totalUsers;
    } catch (e) {
      if (!mounted) return 0;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Error loading user count: $e');
      return 0; // ✅ catch ব্লকেও return দিতে হবে
    }
  }




  @override
  Widget build(BuildContext context) {
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

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Total Member & Admin
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(userTotal.toString(),style: TextStyle(
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(adminTotal.toString(),style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),),
                            Text('Total Admin',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: StreamBuilder<int>(
                      stream: _adminHomeService.getAllUsersTotalAmountStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final totalAmount = snapshot.data ?? 0;
                        return Text(
                          '$totalAmount Tk',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        );
                      },
                    )


                    ,
                  ),
                ),
              ),
            )
            ,

            Row(
              children: [
                //Saving Money Button
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>SavingMoneyScreen()));
                  },
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/taka.png',
                            width: 80,
                            height: 50,),
                          SizedBox(height: 5,),
                          Text('Saving Money',style: TextStyle(
                              fontSize: 16,color: Colors.white
                          ),)

                        ],
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
                ),
              ],
            ),
            Row(
              children: [
                //Saving Money Button
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>SavingMoneyScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/log.png',
                            color: Colors.white,
                            width: 80,
                            height: 50,),
                          SizedBox(height: 5,),
                          Text('Admin Log',style: TextStyle(
                              fontSize: 16,color: Colors.white
                          ),)

                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                //delete button
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>MoneyDeleteSimpleScreen()));
                  },
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/delete_report.png',
                            color: Colors.red.shade200,
                            width: 80,
                            height: 50,),
                          SizedBox(height: 5,),
                          Text('Delete Record',maxLines: 2,style: TextStyle(
                              fontSize: 16,color: Colors.white
                          ),)

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            //Note button
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=>NoteScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  height: 150,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/notes.png',
                        color: Colors.white,
                        width: 80,
                        height: 50,),
                      SizedBox(height: 5,),
                      Text('Notice board',maxLines: 2,style: TextStyle(
                          fontSize: 16,color: Colors.white
                      ),)

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
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
