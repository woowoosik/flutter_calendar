import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*

class ScheduleUpdatePage extends StatefulWidget{

  var startTime ;
  var endTime;
  var schedule;

  ScheduleUpdatePage({Key? key, required this.startTime, required this.endTime, required this.schedule});

  @override
  State<StatefulWidget> createState() {
    return _ScheduleUpdatePage();
  }
}

class _ScheduleUpdatePage extends State<ScheduleUpdatePage>{

  TimeOfDay startTime = TimeOfDay.now();

  TimeOfDay endTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    startTime = TimeOfDay.fromDateTime(DateTime(1,1,1,widget.startTime.toInt(),0,0));
    endTime = TimeOfDay.fromDateTime(DateTime(1,1,1,widget.endTime.toInt(),0,0));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          startTime = timeOfDay;
                        });
                      }
                    },
                    child: Text(
                      '${startTime.hour}:${startTime.minute}',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                      );
                      if (timeOfDay != null) {
                        setState(() {
                          endTime = timeOfDay;
                        });
                      }
                    },
                    child: Text(
                      '${endTime.hour}:${endTime.minute}',
                      style: TextStyle(fontSize: 40),
                    ),
                  )
                ],
              ),

              Text('${widget.schedule.content}'),

              ElevatedButton(
                  onPressed: (){

                  },
                  child: Text('수정'),
              ),

            ]
        ) ,
      ),
    );
  }
}

*/
