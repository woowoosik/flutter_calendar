/*

import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;
  final String content;
  final DateTime date;
  final int startTime;
  final int endTime;
  final GoogleMapCheck? googleMapCheck;
  final Alarm? alarm;

  ScheduleModel({
    required this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.googleMapCheck,
    required this.alarm,
  });

  ScheduleModel.fromJson({ // 1 JSON으로부터 모델을 만들어내는 생성자
    required Map<dynamic, dynamic>? json,
  })  : id = json?['id'] ,
        content = json?['content'] ,
        date = (json?["date"] as Timestamp).toDate(),
        startTime = json?['startTime'],
        endTime = json?['endTime'],
        googleMapCheck = json?['googleMapCheck'] ==
        null 
            ? GoogleMapCheck(isChecked: false, googleMapData: GoogleMapData(lat: 0.0, lng: 0.0, name: "없음", formatted_address: "없음") ) 
            : GoogleMapCheck.fromJson(json: json?['GoogleMapCheck']),
        alarm = json?['alarm'] == null? null:Alarm.fromJson(json: json?['alarm']);




  Map<String, dynamic> toJson() {  // 2 모델을 다시 JSON으로 변환하는 함수
    return {
      'id': id,
      'content': content,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'googleMapCheck' : googleMapCheck?.toJson(),
      'alarm' : alarm?.toJson(),
    };
  }

  ScheduleModel copyWith({  // 3 현재 모델을 특정 속성만 변환해서 새로 생성
    String? id,
    String? content,
    DateTime? date,
    int? startTime,
    int? endTime,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      content: content ?? this.content,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

}

class GoogleMapCheck{
  final bool isChecked;
  final GoogleMapData? googleMapData;

  GoogleMapCheck({required this.isChecked, required this.googleMapData});

  GoogleMapCheck.fromJson({
    required Map<dynamic,dynamic>? json,
  }):
        isChecked = json?['isChecked'] ?? false,
        googleMapData = json?['GoogleMapData'] ==
            null ? GoogleMapData(lat: 0.0, lng: 0.0, name: "없음", formatted_address: "없음") 
            : GoogleMapData.fromJson(json: json?['GoogleMapData']);



  
  Map<String, dynamic> toJson() {
    return {
      'isChecked' : isChecked,
      'googleMapData' : googleMapData?.toJson(),
    };
  }
}

class GoogleMapData {
  final double? lat;
  final double? lng;
  final String? name;
  final String? formatted_address;

  GoogleMapData({
    required this.lat,
    required this.lng,
    required this.name,
    required this.formatted_address,
  });

  GoogleMapData.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
        lat = json['lat'],
        lng = json['lng'],
        name = json['name'],
        formatted_address = json['formatted_address'];


  Map<String, dynamic> toJson() {
    return {
      'lat' : lat,
      'lng' : lng,
      'name' : name,
      'formatted_address' : formatted_address,
    };
  }

}


class Alarm{
  final bool isChecked;
  final AlarmData? alarmData;

  Alarm({required this.isChecked, required this.alarmData});

  Alarm.fromJson({
    required Map<dynamic,dynamic>? json,
  })  :
        isChecked = json?['isChecked'] ?? false,
        alarmData = json?['alarmData'] == null ? AlarmData(alarmDate: 11110101, alarmTime: 11110102, id: 0000) : AlarmData.fromJson(json: json?['alarmData']);

  Map<String, dynamic> toJson() {
    return {
      'isChecked' : isChecked,
      'alarmData' : alarmData?.toJson(),
    };
  }

}


class AlarmData{
  final int id;
  final int alarmDate;
  final int alarmTime;

  AlarmData({required this.alarmDate, required this.alarmTime, required this.id});

  AlarmData.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
        id = json['id'],
        alarmDate = json['alarmDate'],
        alarmTime = json['alarmTime'];

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'alarmTime' : alarmTime,
      'alarmDate' : alarmDate,
    };
  }



}

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;
  final String content;
  final DateTime date;
  final int startTime;
  final int endTime;
  final GoogleMapCheck? googleMapCheck;
  final Alarm? alarm;

  ScheduleModel({
    required this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.googleMapCheck,
    required this.alarm,
  });

  ScheduleModel.fromJson({ // 1 JSON으로부터 모델을 만들어내는 생성자
    required Map<dynamic, dynamic>? json,
  })  : id = json?['id'] ,
        content = json?['content'] ,
        date = (json?["date"] as Timestamp).toDate(),
        startTime = json?['startTime'],
        endTime = json?['endTime'],
        googleMapCheck = json?['googleMapCheck'] ==
            null
            ? /*GoogleMapCheck(
                isChecked: false,
                googleMapData: GoogleMapData(lat: 0, lng: 0, name: "name", formatted_address: "formatted_address")
              )*/null
            : GoogleMapCheck.fromJson(json: json!['googleMapCheck']),
        alarm = json?['alarm'] == null? null:Alarm.fromJson(json: json!['alarm']);




  Map<String, dynamic> toJson() {  // 2 모델을 다시 JSON으로 변환하는 함수
    return {
      'id': id,
      'content': content,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'googleMapCheck' : googleMapCheck?.toJson(),
      'alarm' : alarm?.toJson(),
    };
  }

}

class GoogleMapCheck{
  final bool isChecked;
  final GoogleMapData? googleMapData;

  GoogleMapCheck({required this.isChecked, required this.googleMapData});

  GoogleMapCheck.fromJson({
    required Map<dynamic,dynamic>? json,
  })  :
        isChecked = json?['isChecked'] ?? false,
        googleMapData = json?['googleMapData'] == null
            ? null
            : GoogleMapData.fromJson(json: json!['googleMapData']);


  Map<String, dynamic> toJson() {
    return {
      'isChecked' : isChecked,
      'googleMapData' : googleMapData?.toJson(),
    };
  }
}

class GoogleMapData {
  final double? lat;
  final double? lng;
  final String? name;
  final String? formatted_address;

  GoogleMapData({
    required this.lat,
    required this.lng,
    required this.name,
    required this.formatted_address,
  });

  GoogleMapData.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
        lat = json['lat'],
        lng = json['lng'],
        name = json['name'],
        formatted_address = json['formatted_address'];


  Map<String, dynamic> toJson() {
    return {
      'lat' : lat,
      'lng' : lng,
      'name' : name,
      'formatted_address' : formatted_address,
    };
  }

}


class Alarm{
  final bool isChecked;
  final AlarmData? alarmData;

  Alarm({required this.isChecked, required this.alarmData});

  Alarm.fromJson({
    required Map<dynamic,dynamic>? json,
  })  :
        isChecked = json?['isChecked'] ?? false,
        alarmData = json?['alarmData'] == null ? null : AlarmData.fromJson(json: json!['alarmData']);

  Map<String, dynamic> toJson() {
    return {
      'isChecked' : isChecked,
      'alarmData' : alarmData?.toJson(),
    };
  }

}


class AlarmData{
  final int id;
  final int alarmDate;
  final int alarmTime;

  AlarmData({required this.alarmDate, required this.alarmTime, required this.id});

  AlarmData.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
        id = json['id'],
        alarmDate = json['alarmDate'],
        alarmTime = json['alarmTime'];

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'alarmTime' : alarmTime,
      'alarmDate' : alarmDate,
    };
  }



}

