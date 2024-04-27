import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


typedef Callback = void Function(TimeOfDay);

class StartTimePickerWidget extends StatefulWidget{

  var startTime;

  final Callback callback;

  StartTimePickerWidget({super.key, required this.startTime, required this.callback});


  @override
  State<StatefulWidget> createState() {
    return _StartTimePickerWidget();
  }
}

class _StartTimePickerWidget extends State<StartTimePickerWidget>{

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(
                Icons.access_time,
                size: 30.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "시작시간",
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: widget.startTime,
              );
              if (timeOfDay != null) {
                setState(() {
                  widget.startTime = timeOfDay;
                  widget.callback.call(widget.startTime);
                  print("start time picker : ${widget.startTime}");
                });
              }
            },
            child: Text(
              '${widget.startTime.hour}:${widget.startTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}