import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



typedef AlarmCheckedCallback = void Function(bool);
typedef Callback = void Function(DateTime, TimeOfDay);

class FcmAlarmWidget extends StatefulWidget{

  var alarmChecked = false;
  var alarmDate = DateTime.now().add(Duration(days: 1));
  var alarmTime = TimeOfDay.fromDateTime(DateTime.now());

  final Callback callback;
  final AlarmCheckedCallback alarmCheckedCallback;

  FcmAlarmWidget({
    super.key,
    required this.alarmChecked,
    required this.alarmDate,
    required this.alarmTime,
    required this.alarmCheckedCallback,
    required this.callback
  });

  @override
  State<StatefulWidget> createState() {
    return _FcmAlarmWidget();
  }
}

class _FcmAlarmWidget extends State<FcmAlarmWidget>{
  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.alarm_on,
                size: 30.0,
              ),
              const SizedBox(
                width: 5,
              ),

              Visibility(
                visible: !widget.alarmChecked,
                child: const Text(
                  "푸시알림",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Visibility(
                visible: widget.alarmChecked,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? dateTime = await showDatePicker(
                            context: context,
                            initialDate: widget.alarmDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(9999));
                        if (dateTime != null) {
                          setState(() {
                            widget.alarmDate = dateTime;
                            widget.callback.call(widget.alarmDate, widget.alarmTime);
                          });
                        }
                      },
                      child: Text(
                        '${widget.alarmDate.year}-${widget.alarmDate.month.toString().padLeft(2, '0')}-${widget.alarmDate.day.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: widget.alarmTime,
                        );
                        if (timeOfDay != null) {
                          setState(() {
                            widget.alarmTime = timeOfDay;
                            widget.callback.call(widget.alarmDate, widget.alarmTime);
                          });
                        }
                      },
                      child: Text(
                        '(${widget.alarmTime.hour}:${widget.alarmTime.minute.toString().padLeft(2, '0')})',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Switch(
                value: widget.alarmChecked,
                onChanged: (value) {
                  setState(() {
                    widget.alarmChecked = value;
                    widget.alarmCheckedCallback.call(value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}