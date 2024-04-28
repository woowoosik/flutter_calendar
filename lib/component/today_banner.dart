import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_calendar/color/colors.dart';

class TodayBanner extends StatelessWidget{
  final DateTime selectedDate;
  final int count;
  final DateTime weekDate;

  const TodayBanner({Key? key, required this.selectedDate, required this.count, required this.weekDate}):super(key: key);


  @override
  Widget build(BuildContext context) {

    print("today banner weekDate : ${weekDate}");
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: textColor(weekDate.month),
    );

    return Container(
      color: color(weekDate.month),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: image(weekDate.month),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${selectedDate.year}년  ${selectedDate.month}월  ${selectedDate.day}일',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
                Text(
                  '${count}개',
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


Widget image(int month){
  if(3<= month && month <=5){
    return Image.asset('assets/tree_01.png', height: 50, fit: BoxFit.fitHeight);
  }else if(6<= month && month <=8){
    return Image.asset('assets/tree_02.png', height: 50, fit: BoxFit.fitHeight);
  }else if(9<= month && month <=11){
    return Image.asset('assets/tree_03.png', height: 50, fit: BoxFit.fitHeight);
  }else{
    return Image.asset('assets/tree_04.png', height: 50, fit: BoxFit.fitHeight);
  }

}

Color color(int month){
  if(3<= month && month <=5){
    return SEASON_COLOR_01;
  }else if(6<= month && month <=8){
    return SEASON_COLOR_02;
  }else if(9<= month && month <=11){
    return SEASON_COLOR_03;
  }else{
    return SEASON_COLOR_04;
  }
}

Color textColor(int month){
  if(3<= month && month <=5){
    return SEASON_COLOR_TEXT_01;
  }else if(6<= month && month <=8){
    return SEASON_COLOR_TEXT_02;
  }else if(9<= month && month <=11){
    return SEASON_COLOR_TEXT_03;
  }else{
    return SEASON_COLOR_TEXT_04;
  }
}