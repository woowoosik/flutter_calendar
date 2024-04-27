import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/firebase_options.dart';
import 'package:schedule_calendar/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_calendar/login/log_utils.dart';
import 'package:schedule_calendar/login/sign_in_page.dart';

class LoginPage extends StatefulWidget{

  late var userUid;

  final idController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage>{

  Logger logger = Logger();


  @override
  Widget build(BuildContext context) {


    print("@@@@ ${getUser()}");
    widget.userUid = getUser()?.uid;

   /*
     위 코드를 통해 문제가 해결되는 이유는 addPostFrameCallback을 통해 build가 끝나고
     한 프레임이 렌더링된 이후에 인자로 넘긴 콜백 함수가 실행되므로 setState가 호출되는
     시점이 build가 끝난 후 StatefulWidget에서 실행되는 것과 같아 위 문제점에서 얘기했던
     target이 rebuild 시작점보다 깊은 곳에 있는 문제가 발생하지 않는 것이다.
    */
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(widget.userUid != null){
        navigator(context, HomePage());
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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

                      textWidget('이메일을 입력해주세요.', const Icon(Icons.email_outlined), widget.idController),
                      SizedBox(height: 10,),
                      textWidget('비밀번호를 입력해주세요.', const Icon(Icons.lock_outline_rounded), widget.passwordController),
                      SizedBox(height: 30,),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                            backgroundColor: LOGIN_BUTTON_COLOR,
                          ),
                          onPressed: () async {
                            login();
                          },
                          child: Text(
                            "로그인",
                            style: TextStyle(
                              color: LOGIN_TEXT_COLOR,
                            ),
                          )
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                            backgroundColor: SIGNIN_BUTTON_COLOR,
                          ),
                          onPressed: () async {
                            signInPage(context);
                          },

                          child: Text(
                            "가입하기",
                            style: TextStyle(
                              color: LOGIN_TEXT_COLOR,
                            ),)
                      ),



                    ],
                  ),
                ),


        ),
      ),


    );


  }
/*

  /// 로그인
  Future<bool> signIn(String email, String pw) async{

    print("로그인 ${email}  $pw");

    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email,
          password: pw)
          .then((value) => navigator(context, HomePage()));
    } catch (e) {
      debugPrint('에러');
    }


    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pw
      );


      print("signIn  ::  ${credential.user?.getIdToken()}");
      if(credential.user?.getIdToken() != null){
        print("signIn  ::  ${credential.user}");
        return false;
      }else{
        print("signIn  ::  ${credential.user}");
        return true;
      }

    } on FirebaseAuthException catch (e) {
      print("signIn  ::  FirebaseAuthException");
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }

    }

    print("signIn  ::  false");
    return false;

  }

*/

  void navigator(BuildContext context, dynamic movePage){
    // widget.userUid = getUser()?.uid;

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
          movePage,
      ), (route) => false
    );

  }

  Future<void> login() async {
    CircularProgressIndicator();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: widget.idController.text,
          password: widget.passwordController.text)
          .then((value) => navigator(context, HomePage()));
    } catch (e) {
      showToast("아이디와 비밀번호를 확인해주세요");
    }
  }


  void signInPage(BuildContext context){
    Navigator.push(
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
          SignInPage(),
        )
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
        onSubmitted: (value){
          login();
        },
      ),
    );
  }




}
