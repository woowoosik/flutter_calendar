import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


typedef Callback = void Function(TimeOfDay);

class EndTimePickerWidget extends StatefulWidget{
  var endTime;

  final Callback callback;

  EndTimePickerWidget({super.key, required this.endTime, required this.callback});


  @override
  State<StatefulWidget> createState() {
    return _EndTimePickerWidget();
  }
}

class _EndTimePickerWidget extends State<EndTimePickerWidget>{

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
                Icons.access_time_filled,
                size: 30.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "종료시간",
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: widget.endTime,
              );
              if (timeOfDay != null) {
                setState(() {
                  widget.endTime = timeOfDay;
                  widget.callback.call(widget.endTime);
                });
              }
            },
            child: Text(
              '${widget.endTime.hour}:${widget.endTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }

}