import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule_calendar/color/colors.dart';

class TodayBanner extends StatelessWidget{
  final DateTime selectedDate;
  final int count;

  const TodayBanner({Key? key, required this.selectedDate, required this.count}):super(key: key);


  @override
  Widget build(BuildContext context) {

   // var image = imageNum(selectedDate.month);

   // print("image @ ${image}");
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.brown,
    );

    return Container(
      child: Stack(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: image(selectedDate.month),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedDate.year}년  ${selectedDate.month}월  ${selectedDate.day}일',
                  style: textStyle,
                ),
                Text(
                  '${count}개',
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
    return Image.asset('assets/01.jpg');
  }else if(4<= month && month <=6){
    return Image.asset('assets/02.jpg');
  }else if(7<= month && month <=9){
    return Image.asset('assets/03.jpg');
  }else{
    return Image.asset('assets/04.jpg');
  }

}
