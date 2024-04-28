import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_calendar/login/log_utils.dart';
import 'package:schedule_calendar/login/text_field_widget.dart';

class SignInPage extends StatefulWidget {
  late var userUid;

  final idController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
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
              TextFieldWidget(
                password: false,
                hint: '사용할 이메일을 입력해주세요.',
                icon: const Icon(Icons.email_outlined),
                controller: widget.idController,
                callback: () async {
                  CircularProgressIndicator();
                  if (await createUser(widget.idController.text,
                      widget.passwordController.text)) {
                    navigator(context);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                password: true,
                hint: '사용할 비밀번호를 입력해주세요.',
                icon: const Icon(Icons.lock_outline_rounded),
                controller: widget.passwordController,
                callback: () async {
                  const CircularProgressIndicator();
                  if (await createUser(widget.idController.text,
                      widget.passwordController.text)) {
                    navigator(context);
                  }
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
                  const CircularProgressIndicator();
                  if (await createUser(widget.idController.text,
                      widget.passwordController.text)) {
                    navigator(context);
                  } else {
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
            ],
          ),
        ),
      ),
    );
  }

  void navigator(BuildContext context) {
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
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        ),
        (route) => false);
  }
}
