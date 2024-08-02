// import 'package:chat_app/pages/signup.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//
//   String email="";
//   final _formkey = GlobalKey<FormState>();
//   TextEditingController usermailcontroller = new TextEditingController();
//
//   resetPassword()async{
//     try{
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Password Reset Email has been  sent",style: TextStyle(fontSize: 18.0),)));
//
//     } on FirebaseAuthException catch(e){
//       if(e.code=="user-not-found"){
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("No User Found For That Email",style: TextStyle(fontSize: 18.0),)));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           child: Stack(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height/4.0,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(colors: [Color(0xFF7f30fe),Color((0xFF6380fb))],begin: Alignment.topLeft,end: Alignment.bottomRight),
//                     borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 105.0))),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 70.0),
//                 child: Column(
//                   children: [
//                     Center(child:Text("Password Recovery", style: TextStyle(color: Colors.white,fontSize: 24.0,fontWeight:FontWeight.bold),) ),
//                     Center(child:Text("Enter your email", style: TextStyle(color: Color(0xFFbbb0ff),fontSize: 18.0,fontWeight:FontWeight.w500),) ),
//                     Container(
//                       margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
//                       child: Material(
//                         elevation: 5.0,
//                         borderRadius: BorderRadius.circular(10),
//                         child: Container(
//                           margin: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
//                           height: MediaQuery.of(context).size.height/2,
//                           width: MediaQuery.of(context).size.width,
//                           decoration: BoxDecoration(color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),),
//                           child: Form(
//                             key: _formkey,
//                             child: Column(
//                               children: [
//                                 Text("Email",style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.w500),),
//                                 SizedBox(height: 10.0,),
//                                 Container(
//                                   decoration: BoxDecoration(border:Border.all(width: 1.0,color: Colors.black38)),
//                                   child: TextFormField(
//                                     controller: usermailcontroller,
//                                     validator: (value){
//                                       if(value==null || value.isEmpty){
//                                         return'Please Enter Email';
//                                       }
//                                       return null;
//                                     },
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       prefixIcon: Icon(Icons.mail_outline,color: Color(0xFF7f30fe)),
//                                     ),
//
//                                   ),
//                                 ),
//
//                                 SizedBox(height: 50.0,),
//                                 GestureDetector(
//                                   onTap: (){
//                                     if(_formkey.currentState!.validate()){
//                                       setState(() {
//                                         email= usermailcontroller.text;
//                                       });
//                                       resetPassword();
//                                     }
//
//                                   },
//                                   child: Center(
//                                     child: Container(
//                                       width: 130,
//                                       child: Material(
//                                         elevation: 5.0,
//                                         borderRadius: BorderRadius.circular(10),
//                                         child: Container(
//
//                                           padding: EdgeInsets.all(10),
//                                           decoration: BoxDecoration(color: Color(0xFF6380fb),borderRadius: BorderRadius.circular(10)),
//                                           child: Center(
//                                             child: Text("Send Email",style: TextStyle(color: Colors.white,
//                                                 fontSize: 18.0,
//                                                 fontWeight: FontWeight.bold),),
//                                           ),),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 40.0,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Don't have an account?",style: TextStyle(color: Colors.black,fontSize: 16.0),),
//                         Text("SignUp Now",style: TextStyle(color: Color(0xFF7f30fe),fontSize: 16.0,fontWeight: FontWeight.w500),),
//                         GestureDetector(
//                           onTap: (){
//                             Navigator.push(
//                                 context,MaterialPageRoute(builder: (context)=>Signup())
//                             );
//                           },
//                         )
//                       ],
//                     )
//
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'package:chat_app/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  final _formkey = GlobalKey<FormState>();
  TextEditingController usermailcontroller = TextEditingController();

  Future<void> resetPassword() async {
    if (_formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Password Reset Email has been sent",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "No User Found For That Email",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "An error occurred: ${e.message}",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "An unexpected error occurred",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      105.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Password Recovery",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Enter your email",
                        style: TextStyle(
                          color: Color(0xFFbbb0ff),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.0, color: Colors.black38),
                                  ),
                                  child: TextFormField(
                                    controller: usermailcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Email';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      email = value;  // Update email whenever the text changes
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF7f30fe)),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 50.0),
                                GestureDetector(
                                  onTap: resetPassword,
                                  child: Center(
                                    child: Container(
                                      width: 130,
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6380fb),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Send Email",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Signup()),
                            );
                          },
                          child: Text(
                            "SignUp Now",
                            style: TextStyle(
                              color: Color(0xFF7f30fe),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

