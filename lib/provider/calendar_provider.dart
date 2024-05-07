import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger_plus/logger_plus.dart';

class CalendarProvider extends ChangeNotifier{

  Map<DateTime, List<dynamic>> events = {};

  void removeEvent(DateTime dateTime, dynamic id){

    Logger().d("removeEvent  ${dateTime}  ${id}");
    for(var s =0; s< events[dateTime]!.length; s++){
      if( events[dateTime]![s].id == id){
        events[dateTime]!.removeAt(s);
      }
    }

    notifyListeners();
  }

  void addEvent(DateTime dateTime, dynamic e) {

    Logger().d("addEvent  ${dateTime}  ${e}");

    if(events[dateTime] != null){
      events[dateTime]?.add(e);   //   키 값 있을때
    }else{
      events.putIfAbsent(dateTime, () => [e]);  //  키 값 없을때
    }


    notifyListeners();
  }

  void getEvents(dynamic e){
    events = e;
    Logger().d("getEvents ${events}");
  }











}