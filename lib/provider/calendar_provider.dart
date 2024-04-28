import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CalendarProvider extends ChangeNotifier{

  Map<DateTime, List<dynamic>> events = {};

  void removeEvent(DateTime dateTime, dynamic id){

    print("removeEvent  ${dateTime}  ${id}");
    for(var s =0; s< events[dateTime]!.length; s++){
      if( events[dateTime]![s].id == id){
        events[dateTime]!.removeAt(s);
      }
    }

    notifyListeners();
  }

  void addEvent(DateTime dateTime, dynamic e) {

    // events[dateTime]?.add(e);
    print("addEvent  ${dateTime}  ${e}");

    if(events[dateTime] != null){
      events[dateTime]?.add(e);   //   키 값 있을때
    }else{
      events.putIfAbsent(dateTime, () => [e]);  //  키 값 없을때
    }

    print("addEvent  ${dateTime}  ${events}");

    notifyListeners();
  }

  void getEvents(dynamic e){
    events = e;
    print("!! ${events}");
  }











}