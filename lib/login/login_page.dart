import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/firebase_options.dart';
import 'package:schedule_calendar/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_calendar/login/log_utils.dart';
import 'package:schedule_calendar/login/sign_in_page.dart';
import 'package:schedule_calendar/login/text_field_widget.dart';

class LoginPage extends StatefulWidget {
  late var userUid;

  final idController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    widget.userUid = getUser()?.uid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Logger().d('addPostFrameCallback');
      if (widget.userUid != null) {
        navigator(context, HomePage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d(" logger : @@@@ _LoginPage build ${getUser()} @@@@");

    // widget.userUid = getUser()?.uid;

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

                const SizedBox(
                  height: 40,
                ),

                //textWidget('이메일을 입력해주세요.', const Icon(Icons.email_outlined), widget.idController),
                TextFieldWidget(
                  password: false,
                  hint: '이메일을 입력해주세요.',
                  icon: const Icon(Icons.email_outlined),
                  controller: widget.idController,
                  callback: () {
                    login();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                //textWidget('비밀번호를 입력해주세요.', const Icon(Icons.lock_outline_rounded), widget.passwordController),
                TextFieldWidget(
                  password: true,
                  hint: '비밀번호를 입력해주세요.',
                  icon: const Icon(Icons.lock_outline_rounded),
                  controller: widget.passwordController,
                  callback: () {
                    login();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      backgroundColor: LOGIN_BUTTON_COLOR,
                    ),
                    onPressed: () async {
                      login();
                    },
                    child: const Text(
                      "로그인",
                      style: TextStyle(
                        color: LOGIN_TEXT_COLOR,
                      ),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      backgroundColor: SIGNIN_BUTTON_COLOR,
                    ),
                    onPressed: () async {
                      signInPage(context);
                    },
                    child: const Text(
                      "가입하기",
                      style: TextStyle(
                        color: LOGIN_TEXT_COLOR,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigator(BuildContext context, dynamic movePage) {
    Logger().d("navigator");
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
          pageBuilder: (context, animation, secondaryAnimation) => movePage,
        ),
        (route) => false);
  }

  Future<void> login() async {
    const CircularProgressIndicator();
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

  void signInPage(BuildContext context) {
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
          pageBuilder: (context, animation, secondaryAnimation) => SignInPage(),
        ));
  }


}
