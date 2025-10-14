import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_pwa_app_01/cachehelper/chechehelper.dart';
import 'package:firebase_pwa_app_01/user/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin/home/screen/adminhome_screen.dart';
import 'auth/screen/login_screen.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _checkLogin() async {
    final isLoggedIn =await CacheHelper().getLoggedIn();
    final role = await CacheHelper().getString('isRole');

    if (isLoggedIn) {
      if (role == "Admin") {
        return const AdminHomeScreen();
      } else if(role == "User") {
        return const HomeScreen();
      }else{
        return const LoginScreen();
      }
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(
          future: _checkLogin(),
          builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
           Center(child: CircularProgressIndicator(),);
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );

        }else if(snapshot.hasData){
          return snapshot.data!;
        }else{
          return const LoginScreen();
        }

          }),
    );
  }

}


