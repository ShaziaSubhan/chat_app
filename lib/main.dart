// import 'package:chat_app/pages/chatpage.dart';
// import 'package:chat_app/pages/home.dart';
// import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/pages/forgotpassword.dart';
import 'package:chat_app/pages/home.dart';
import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/pages/signup.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAXT7yPePC5ng51feoEJGTbPseh7LB6KkQ",
        appId: 'appId',
        messagingSenderId: 'messagingSenderId',
        projectId:  "chatapp2-d15a6",
        storageBucket: "chatapp2-d15a6.appspot.com",
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:FutureBuilder(
        future: AuthMethods().getcurrentUser(),

          builder: (context,AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          return Home();
        }else{
          return Signup();
        }
      }),
    );

  }
}
