import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

import 'home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  String email="", password="", name="", confirmPassword="";
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  final _formkey =GlobalKey<FormState>();

  registration()async{
    if(password!=null && password==confirmPassword){
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email,password:password);

        String Id =randomAlphaNumeric(10);
        String user =emailController.text.replaceAll("@gmail.com", "");
        String updateusername = user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter = user.substring(0,1).toUpperCase();

        Map<String, dynamic>userInfoMap={
          "Name":nameController.text,
          "Email":emailController.text,
          "username":updateusername.toUpperCase(),
          "SearchKey":firstletter,
          "Photo":"https://stock.adobe.com/in/images/profile-gradient-icon/483909569",
          "Id":Id,

        };

        await DatabaseMethods().adduserDetails(userInfoMap, Id);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserDisplayName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserPic("https://stock.adobe.com/in/images/profile-gradient-icon/483909569");
        await SharedPreferenceHelper().saveUserName(emailController.text.replaceAll("@gmail.com","").toUpperCase());

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registered Successfully",style: TextStyle(fontSize: 20.0),)));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      }on FirebaseAuthException catch(e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text("Password provided is too weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already Exists", style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Container(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/4.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF7f30fe),Color((0xFF6380fb))],begin: Alignment.topLeft,end: Alignment.bottomRight),
                      borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: Column(
                    children: [
                      Center(child:Text("SIGN UP", style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight:FontWeight.bold),) ),
                      Center(child:Text("Create a new account", style: TextStyle(color: Color(0xFFbbb0ff),fontSize: 18.0,fontWeight:FontWeight.w500),) ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                            height: MediaQuery.of(context).size.height/1.6,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.circular(10),),
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Text("Name",style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    decoration: BoxDecoration(border:Border.all(width: 1.0,color: Colors.black38)),
                                    child: TextFormField(
                                      controller: nameController,
                                      validator: (value){
                                        if(value==null || value.isEmpty){
                                          return'Please Enter Name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.person_outline,color: Color(0xFF7f30fe)),
                                      ),
            
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
                                  Text("Email",style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    decoration: BoxDecoration(border:Border.all(width: 1.0,color: Colors.black38)),
                                    child: TextFormField(
                                      controller: emailController,
                                      validator: (value){
                                        if(value==null || value.isEmpty){
                                          return'Please Enter Email';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.mail_outline,color: Color(0xFF7f30fe)),
                                      ),
            
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
                                  Text("Password",style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    decoration: BoxDecoration(border:Border.all(width: 1.0,color: Colors.black38)),
                                    child: TextFormField(
                                      controller: passwordController,
                                      validator: (value){
                                        if(value==null || value.isEmpty){
                                          return'Please Enter Password';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.password,color: Color(0xFF7f30fe)),
                                      ),
                                      obscureText: true,
            
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
                                  Text("Confirm Password",style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w500),),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    decoration: BoxDecoration(border:Border.all(width: 1.0,color: Colors.black38)),
                                    child: TextFormField(
                                      controller: confirmPasswordController,
                                      validator: (value){
                                        if(value==null || value.isEmpty){
                                          return'Please Enter ConfirmPassword';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.password,color: Color(0xFF7f30fe)),
                                      ),
                                      obscureText: true,
            
                                    ),
                                  ),
            
                                  SizedBox(height: 30.0,),
                                  // SizedBox(height: 30.0,),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Don't have an account?",style: TextStyle(color: Colors.black,fontSize: 16.0),),
                                        SizedBox(height: 10.0,),

                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                                context,MaterialPageRoute(builder: (context)=>SignIn())
                                            );
                                          },
                                          child:Text("SignIn Now",style: TextStyle(color: Color(0xFF7f30fe),fontSize: 16.0,fontWeight: FontWeight.w500),),
                                        ),
                                      ],
                                    ),
                                  ),
            
                                ],
                              ),
                            ),
            
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
            
                     GestureDetector(
                          onTap: (){
                            if(_formkey.currentState!.validate()) {
                              setState(() {
                                name = nameController.text;
                                email = emailController.text;
                                password = passwordController.text;
                                confirmPassword = confirmPasswordController.text;
                              });
                                
                              registration();
                            }
                          },
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              width: MediaQuery.of(context).size.width,
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: Color(0xFF6380fb),borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text("SIGNUP",style: TextStyle(color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),),

                                  ),),
                              ),
                            ),
                          ),
                        ),
                    
                    ],
                  ),
                )
              ],
            ),
          ),
      ),

    );
  }
}
