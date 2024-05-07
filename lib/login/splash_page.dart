import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger_plus/logger_plus.dart';
import 'package:schedule_calendar/calendar_week.dart';
import 'package:schedule_calendar/home_page.dart';
import 'package:schedule_calendar/login/log_utils.dart';
import 'package:schedule_calendar/login/login_page.dart';

class SplashPage extends StatefulWidget {
  late var userUid;

  @override
  State<StatefulWidget> createState() {
    return _SplashPage();
  }
}

class _SplashPage extends State<SplashPage> with TickerProviderStateMixin {
  late var userUid;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInToLinear,
  );

  @override
  void initState() {
    super.initState();
    widget.userUid = getUser()?.uid;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userUid != null) {
        splashNavigator(context, HomePage());
      } else {
        splashNavigator(context, LoginPage());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: const Image(
              image: AssetImage("assets/icon.png"),
              width: 200,
              height: 200,
            ),
          ),
        ),
      ),
    );
  }

  void splashNavigator(BuildContext context, Widget movePage) {
    Future.delayed(Duration(milliseconds: 700))
        .then((onValue) => Navigator.push(
              context,
              PageRouteBuilder(
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
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
              ),
            ));
  }
}
