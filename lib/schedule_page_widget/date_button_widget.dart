import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:schedule_calendar/schedule_detail_page.dart';

import '../color/colors.dart';


typedef Callback = void Function();

class DateButtonWidget extends StatefulWidget{

  DateTime date;

  final Callback callback;

  String btnName;

  DateButtonWidget({
    super.key,
    required this.btnName,
    required this.date,
    required this.callback
  });

  @override
  State<StatefulWidget> createState() {

    return _DateButtonWidget();
  }
}

class _DateButtonWidget extends State<DateButtonWidget>{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {
              tz.initializeTimeZones();
              tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              size: 30.0,
            ),
          ),
          Text(
            "${widget.date.year}"
            " - ${widget.date.month.toString().padLeft(2, '0')}"
            " - ${widget.date.day.toString().padLeft(2, '0')}",
            style: const TextStyle(
              color: PRIMARY_COLOR,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            // 3 저장 버튼
            onPressed: () async {
              widget.callback.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text(
              widget.btnName,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
