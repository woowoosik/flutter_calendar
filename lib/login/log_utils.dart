import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/login/login_page.dart';

var logger;

/// 회원가입
Future<bool> createUser(String email, String pw) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: pw,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showToast('비밀번호를 6자리 이상으로 만들어주세요.');
      return false;
    } else if (e.code == 'email-already-in-use') {
      showToast('이미 사용중인 이메일 입니다.');
      return false;
    }
  } catch (e) {
    logger.e(e);
    return false;
  }

  final bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (emailValid) {
    return true;
  } else {
    showToast('이메일 형식에 맞게 적어주세요.');
    return false;
  }
}

/// 로그인
Future<bool> signIn(String email, String pw) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pw);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      logger.w('이미 사용중인 이메일 입니다.');
    } else if (e.code == 'wrong-password') {
      logger.w('Wrong password provided for that user.');
    }
  } catch (e) {
    logger.e(e);
    return false;
  }

  return true;
}

/// 로그아웃
void signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

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
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      ),
      (route) => false);
}

/// 회원가입, 로그인시 사용자 영속
void authPersistence() async {
  await FirebaseAuth.instance.setPersistence(Persistence.NONE);
}

/// 유저 삭제
Future<void> deleteUser(String email) async {
  final user = FirebaseAuth.instance.currentUser;
  await user?.delete();
}

/// 현재 유저 정보 조회
User? getUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final name = user.displayName;
    final email = user.email;
    final photoUrl = user.photoURL;

    final emailVerified = user.emailVerified;

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

/// 공급자로부터 유저 정보 조회
User? getUserFromSocial() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    for (final providerProfile in user.providerData) {
      // ID of the provider (google.com, apple.cpm, etc.)
      final provider = providerProfile.providerId;

      // UID specific to the provider
      final uid = providerProfile.uid;

      // Name, email address, and profile photo URL
      final name = providerProfile.displayName;
      final emailAddress = providerProfile.email;
      final profilePhoto = providerProfile.photoURL;
    }
  }
  return user;
}

/// 유저 이름 업데이트
Future<void> updateProfileName(String name) async {
  final user = FirebaseAuth.instance.currentUser;
  await user?.updateDisplayName(name);
}

/// 유저 url 업데이트
Future<void> updateProfileUrl(String url) async {
  final user = FirebaseAuth.instance.currentUser;
  await user?.updatePhotoURL(url);
}

/// 비밀번호 초기화 메일보내기
Future<void> sendPasswordResetEmail(String email) async {
  await FirebaseAuth.instance.setLanguageCode("kr");
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}
