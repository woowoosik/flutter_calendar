import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_calendar/login/log_utils.dart';

class SignInPage extends StatefulWidget{

  late var userUid;

  final idController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage>{

  Logger logger = Logger();


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                       child: const Image(
                          image: AssetImage("assets/icon.png"),
                          width: 200,
                          height: 200,
                        ),
                    ),
                    SizedBox(height: 40,),

                    textWidget('사용할 이메일을 입력해주세요.', const Icon(Icons.email_outlined), widget.idController),
                    SizedBox(height: 10,),
                    textWidget('사용할 비밀번호를 입력해주세요.', const Icon(Icons.lock_outline_rounded), widget.passwordController),
                    SizedBox(height: 30,),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          backgroundColor: LOGIN_BUTTON_COLOR,
                        ),
                        onPressed: () async {
                          CircularProgressIndicator();
                          if(await createUser(widget.idController.text, widget.passwordController.text)){
                            navigator(context);
                          }else{
                            showToast("가입실패");
                          }
                        },
                        child: const Text(
                          "가입하기",
                          style: TextStyle(
                            color: LOGIN_TEXT_COLOR,
                          ),
                        ),
                    ),



                    /*TextField(
                      controller: idController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '사용할 아이디를 입력해주세요.',
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '사용할 비밀번호를 입력해주세요.',
                      ),
                    ),*/
                  ],
                ),
              ),


      ),
    );

  }

/*

  User? getUser(){
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Name, email address, and profile photo URL
      final name = user.displayName;
      final email = user.email;
      final photoUrl = user.photoURL;

      // Check if user's email is verified
      final emailVerified = user.emailVerified;

      // The user's ID, unique to the Firebase project. Do NOT use this value to
      // authenticate with your backend server, if you have one. Use
      // User.getIdToken() instead.
      final uid = user.uid;


      print("user uid : ${user.uid}");
      print("user get id token : ${user.getIdToken()}");
      print("user name : ${name}");
      print("user email : ${email}");
      print("user photoUrlr : ${photoUrl}");
      print("user emailVerified : ${emailVerified}");

      print("user  : ${user.getIdToken()}");
      print("user  : ${emailVerified}");
    }
    return user;
  }
*/

  void navigator(BuildContext context){

    // widget.userUid = getUser()!.uid;

    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: const Offset(0, 0),
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) =>
              HomePage(),
        ), (route) => false
    );


  }


  Widget textWidget(String hint, Widget icon, dynamic controller){
    return Container(
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe6dfd8), Color(0xFFf7f5ec)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.4],
          tileMode: TileMode.clamp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
      child: TextField(
        controller: controller,
        expands: false,
        style: TextStyle(fontSize: 17.0, color: Colors.black54),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          prefixIcon: icon,
          hintText: hint ,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.black26),
        ),
        keyboardType: TextInputType.text,
        onSubmitted: (value) async {
          CircularProgressIndicator();
          if(await createUser(widget.idController.text, widget.passwordController.text)){
            navigator(context);
          }else{
            showToast("가입실패");
          }
        },

      ),

    );
  }






}