

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:schedule_calendar/login/login_page.dart';

//const root = "JFPZIljXFtUjkSi6jl6qc24lK8J3";
//const root = "schedule";
// var uid = LoginPage().userUid;

final root = FirebaseAuth.instance.currentUser!.uid;

Future<bool> checkPermission() async {

  // 위치권한에 대한 서비스기능을 사용할 수 있는지 ?
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if(!isLocationEnabled){
    //return '위치 서비스를 활성화 해주세요';
    return false;
  }

  //현재 앱이 가지고있는 위치서비스에 대한 권한이 어떻게 되는지 가져온다.
  LocationPermission checkedPermission = await Geolocator.checkPermission();

  // 위치권한 denied 상태일때 (권한 허용이 안되었지만 요청은 할 수 있는 상태)
  if(checkedPermission == LocationPermission.denied){
    checkedPermission = await Geolocator.requestPermission(); // 권한 요청

    //권한 요청 후 또 다시 거부한 경우
    if(checkedPermission == LocationPermission.denied){
      // return '위치 권한을 허가해주세요';
      return false;
    }
  }

  // deniedForever상태인 경우 -> 기기 환경설정 위치설정에서 허가해주어야 함
  if(checkedPermission == LocationPermission.deniedForever) {
    // return '앱의 위치 권한을 기기 세팅에서 허가해주세요';
    return false;
  }

  // return '위치 권한이 허용되었습니다.';
  return true;
}