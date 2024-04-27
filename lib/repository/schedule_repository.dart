import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:schedule_calendar/model/schedule_model.dart';
/*


class ScheduleRepository{
  final _dio = Dio();
  final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';
  // 안드로이드에서는 10.0.2.2가 localhost에 해당함

  Future<List<ScheduleModel>> getSchedules({
    required DateTime date,
  }) async{
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {  // Query 매개변수
        'date' :
            '${date.year}${date.month.toString().padLeft(2,'0')}${date.day.toString().padLeft(2,'0')}',
      },
    );

    return resp.data  // 모델 인스턴스로 데이터 매핑하기
    .map<ScheduleModel>(
        (x) => ScheduleModel.fromJson(json: x),
    ).toList();
  }


  Future<String> createSchedule({
    required ScheduleModel schedule,
  }) async{
    final json = schedule.toJson(); //json 으로 변환

    final resp = await _dio.post(_targetUrl, data: json);

    return resp.data?['id'];
  }

  Future<String> deleteSchedule({
    required String id,
  }) async {
    final resp = await _dio.delete(_targetUrl, data: {'id':id,});

    return resp.data?['id'];
  }


}*/
