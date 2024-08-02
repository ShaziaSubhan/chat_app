import 'package:chat_app/pages/chatpage.dart';
import 'package:chat_app/pages/signin.dart';
import 'package:chat_app/pages/signup.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  String? myName, myProfilePic, myUsername, myEmail;
  Stream? chatRoomsStream;

  getthesharedpref() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUsername = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    chatRoomsStream = await DatabaseMethods().getChatRooms();
    setState(() {});
  }

  Widget ChatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return ChatRoomListTile(
                    chatRoomId: ds.id,
                    lastMessage: ds["lastmessage"],
                    myUsername: myUsername!,
                    time: ds["lastMessageSendTs"].toString());
              })
              : Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['username'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF553370),
        body: SingleChildScrollView(
          child: Container(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    search
                        ? Expanded(
                        child: TextField(
                          onChanged: (value) {
                            initiateSearch(value.toUpperCase());
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search User',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500)),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                        ))
                        : Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back,color: Colors.white,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignIn()),
                                  );
                                },
                              ),

                              Text("ChatUp",
                                style: TextStyle(
                                color: Color(0Xffc199cd),
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                                                  ),
                            ],
                          ),
                        ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            search = !search;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Color(0xFF3a2144),
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            search ? Icons.close : Icons.search,
                            color: Color(0Xffc199cd),
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                height: search
                    ? MediaQuery.of(context).size.height / 1.19
                    : MediaQuery.of(context).size.height / 1.15,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    search
                        ? ListView(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        primary: false,
                        shrinkWrap: true,
                        children: tempSearchStore.map((element) {
                          return buildResultCard(element);
                        }).toList())
                        : ChatRoomList(),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        search = false;
        setState(() {});
        var chatRoomId =
        getChatRoomIdbyUsername(myUsername!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUsername, data["username"]],
        };
        await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                  name: data["Name"],
                  profileurl: data["Photo"],
                  username: data["username"],
                )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    data["Photo"],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.error,
                      size: 70,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      data["username"],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  ChatRoomListTile(
      {required this.chatRoomId,
        required this.lastMessage,
        required this.myUsername,
        required this.time});

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", username = "", id = "";

  getthisUserInfo() async {
    username = widget.chatRoomId
        .replaceAll("_", "")
        .replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot =
    await DatabaseMethods().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    setState(() {});
  }

  @override
  void initState() {
    getthisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
      var chatRoomId = getChatRoomIdbyUsername(widget.myUsername, username);
      Map<String, dynamic> chatRoomInfoMap = {
        "users": [widget.myUsername, username],
      };
      await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            name: name,
            profileurl: profilePicUrl,
            username: username,
          ),
        ),
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePicUrl == ""
                ? CircularProgressIndicator()
                : ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                profilePicUrl,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.error,
                  size: 70,
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        widget.lastMessage,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              ),
            ),
            Spacer(),
            Text(
              widget.time,
              style: TextStyle(
                color: Colors.black45,
                fontSize: 10.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ]),
      ));
  }
}

String getChatRoomIdbyUsername(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}



















// import 'package:chat_app/pages/chatpage.dart';
// import 'package:chat_app/services/database.dart';
// import 'package:chat_app/services/shared_pref.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//
//   bool search= false;
//   String? myName, myProfilePic, myUsername, myEmail;
//   Stream? chatRoomsStream;
//
//   getthesharedpref()async{
//     myName= await SharedPreferenceHelper().getUserDisplayName();
//     myProfilePic = await SharedPreferenceHelper().getUserPic();
//     myUsername = await SharedPreferenceHelper().getUserName();
//     myEmail = await SharedPreferenceHelper().getUserEmail();
//     setState(() {
//
//     });
//   }
//   ontheload()async{
//     await getthesharedpref();
//     chatRoomsStream = await DatabaseMethods().getChatRooms();
//     setState(() {
//
//     });
//   }
//
//   Widget ChatRoomList(){
//     return StreamBuilder(
//         stream: chatRoomsStream,
//         builder:(context,AsyncSnapshot snapshot){
//       return snapshot.hasData?ListView.builder(
//         padding: EdgeInsets.zero,
//           itemCount: snapshot.data.docs.length,
//           shrinkWrap: true,
//           itemBuilder: (context,index){
//         // DocumentSnapshot ds= snapshot.data.doc.length;
//         DocumentSnapshot ds = snapshot.data.docs[index];
//         return ChatRoomListTile(chatRoomId: ds.id, lastmessage: ds["lastmessage"], myUsername: myUsername!, time:ds["lastMessageSendTs"]);
//
//       }): Center(child: CircularProgressIndicator(),);
//
//     });
//
//   }

//   @override
//   void initState(){
//     super.initState();
//     ontheload();
//   }
//   getChatRoomIdbyUsername(String a, String b)
//   {
//     if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
//       return"$b\_$a";
//     }else{
//       return"$a\_$b";
//
//     }
//   }
//
//
//   var queryResultSet=[];
//   var tempSearchStore=[];
//
//   initiateSearch(value){
//     if(value.length==0){
//       setState(() {
//         queryResultSet=[];
//         tempSearchStore=[];
//       });
//     }
//     setState(() {
//       search=true;
//     });
//     var capitalizedValue=value.substring(0,1).toUpperCase()+ value.substring(1);
//     if(queryResultSet.length==0&& value.length==1){
//       DatabaseMethods().Search(value).then((QuerySnapshot docs) {
//         for(int i=0; i<docs.docs.length; i++){
//           queryResultSet.add(docs.docs[i].data());
//         }
//
//       });
//     }else{
//       tempSearchStore=[];
//       queryResultSet.forEach((element){
//         if(element['username'].startsWith(capitalizedValue)){
//           setState(() {
//             tempSearchStore.add(element);
//           });
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF553370),
//       body: SingleChildScrollView(
//         child: Container(
//           // margin: EdgeInsets.symmetric(vertical: 50.0,horizontal: 20.0),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 50.0,bottom: 20.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                      search? Expanded(child: TextField(
//                        onChanged: (value){
//                          initiateSearch(value.toUpperCase());
//                        },
//                        decoration: InputDecoration(border: InputBorder.none,hintText: 'Search User',
//                            hintStyle: TextStyle(color: Colors.black,
//                                fontSize: 20.0,fontWeight:FontWeight.w500)),
//                        style: TextStyle(color: Colors.black,
//                        fontSize: 18.0,fontWeight: FontWeight.w500
//                              ),)):
//                      Text("ChatUp",style: TextStyle(color: Color(0Xffc199cd),
//                         fontSize: 22.0,
//                         fontWeight: FontWeight.bold),),
//                     GestureDetector(
//                       onTap: (){
//                         search= true;
//                         setState(() {
//
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(6),
//                         decoration: BoxDecoration(color: Color(0xFF3a2144),borderRadius: BorderRadius.circular(20)),
//                         child: search? GestureDetector(
//                           onTap: (){
//                             search=false;
//                             setState(() {
//
//                             });
//                           },
//                           child: Icon(
//                             Icons.close,color: Color(0Xffc199cd),),
//                         ):Icon(
//                           Icons.search,color: Color(0Xffc199cd),),
//                       )
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
//                 width: MediaQuery.of(context).size.width,
//                 height:search? MediaQuery.of(context).size.height/1.19: MediaQuery.of(context).size.height/1.15,
//                 decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
//                 child: Column(
//                   children: [
//                     search? ListView(
//                       padding: EdgeInsets.only(left: 10.0,right: 10.0),
//                       primary: false,
//                       shrinkWrap: true,
//                       children: tempSearchStore.map((element){
//                         return buildResultCard(element);
//
//                       }).toList())
//                         :ChatRoomList(),
//
//
//
//             ],
//           ),
//         ),
//             ]),
//             ),
//       )
//     );
//   }
//   Widget buildResultCard(data){
//     return GestureDetector(
//       onTap: ()async{
//         search=false;
//         setState(() {
//
//         });
//         var chatRoomId=getChatRoomIdbyUsername(myUsername!,data["username"]);
//         Map<String,dynamic>chatRoomInfoMap={
//           "users":[myUsername,data["username"]],
//         };
//       await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);
//         Navigator.push(context,MaterialPageRoute(builder:(context)=>ChatPage(name: data["Name"],profileurl: data["Photo"],username: data["username"],)));
//
//
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 8),
//         child: Material(
//           elevation: 5.0,
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             padding: EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: Colors.white,borderRadius: BorderRadius.circular(10)
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(60),
//                     child: Image.network(data["Photo"],height: 70,width: 70,fit: BoxFit.cover,)),
//                 SizedBox(width: 20.0,),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(data["Name"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),
//                     SizedBox(height: 8.0,),
//                     Text(data["username"],style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 15.0),)
//                   ],
//
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//   }
// }
//
// class ChatRoomListTile extends StatefulWidget {
// final String lastmessage, chatRoomId, myUsername, time;
// ChatRoomListTile({required this.chatRoomId,required this.lastmessage, required this.myUsername,required this.time});
//
//   @override
//   State<ChatRoomListTile> createState() => _ChatRoomListTileState();
// }
//
// class _ChatRoomListTileState extends State<ChatRoomListTile> {
//   String profilePicUrl="",name="",username="",id="";
//
//    getthisUserInfo()async{
//      username=widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
//  QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username.toUpperCase());
//      name="${querySnapshot.docs[0]["Name"]}";
//      profilePicUrl="${querySnapshot.docs[0]["Photo"]}";
//      id="${querySnapshot.docs[0]["Id"]}";
//     setState(() {
//
//     });
//    }
//    @override
//    void initState(){
//      getthisUserInfo();
//      super.initState();
//    }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
//       child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             profilePicUrl==""?CircularProgressIndicator():
//             ClipRRect(
//                 borderRadius:BorderRadius.circular(60),
//
//                 child: Image.network(profilePicUrl,height: 70,width: 70,fit: BoxFit.cover,)),
//             SizedBox(width: 20.0,),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 10.0,),
//                 Text(username,style: TextStyle(color: Colors.black,fontSize: 17.0,fontWeight: FontWeight.w500,),),
//
//                 Container(
//                   width: MediaQuery.of(context).size.width/2,
//
//                     child: Text(widget.lastmessage,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(color: Colors.black45,
//                         fontSize: 12.0,fontWeight: FontWeight.w500,),)),
//
//               ],
//             ),
//             Spacer(),
//             Text(widget.time,style: TextStyle(color: Colors.black45,fontSize: 10.0,fontWeight: FontWeight.w500,),),
//
//
//           ]
//       ),
//     );
//   }
// }
//
