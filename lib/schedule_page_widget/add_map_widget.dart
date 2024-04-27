import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/google_map/google_map.dart';
import 'package:schedule_calendar/google_map/google_map_address.dart';
import 'package:schedule_calendar/model/schedule_model.dart';




typedef Callback = void Function(GoogleMapCheck);

class AddMapWidget extends StatefulWidget{

  GoogleMapCheck mapData;

  final Callback callback;

  AddMapWidget({required this.mapData, required this.callback});


  @override
  State<StatefulWidget> createState() {
    return _AddMapWidget();
  }
}

class _AddMapWidget extends State<AddMapWidget>{


  @override
  Widget build(BuildContext context) {

    var mapData = widget.mapData;

    return Column(
      children: [

        Padding(
          padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 30.0,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "맵 추가하기",
                    style: TextStyle(fontSize: 25),
                  ),

                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if(await checkPermission()){
                        mapData = await Navigator.push(context,
                          PageRouteBuilder(
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {

                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: const Offset(0, 0),
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeInOutCubic,
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                              pageBuilder: (context, animation, secondaryAnimation) {
                                //var position = getCurrentLocation();
                                return FutureBuilder(
                                    future: getCurrentLocation(),
                                    builder: (context, s ){
                                      if(s.hasData){
                                        return GoogleMapAddress(position: s.data, mapData: widget.mapData);
                                      }else{
                                        return Scaffold(
                                          body: Center(
                                              child: CircularProgressIndicator(),
                                          ),
                                        );
                                      }
                                    }
                                );
                              }
                          ),
                        );

                      }else{
                        showToast('위치 서비스를 활성화 해주세요.');
                      }

                      setState(() {
                        print("map call back! ${mapData.isChecked}");
                        print("map call back! ${mapData}");
                        widget.mapData = mapData;
                        widget.callback.call(mapData);
                      });
                    },
                    child: Container(
                      child: Text(
                        '지도',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PRIMARY_COLOR
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),


        Visibility(
          visible: widget.mapData.isChecked,
          child: Column(
            children: [
              Text(
                "${widget.mapData.googleMapData?.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Stack(
                children: [
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: GoogleMapPage(
                      lat: widget.mapData.googleMapData?.lat ?? 0,
                      lng: widget.mapData.googleMapData?.lng ?? 0,
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        var map =GoogleMapCheck(
                          isChecked: false,
                          googleMapData: null,
                        );
                        widget.mapData = map;
                        widget.callback.call(map);
                      });
                    },
                    icon: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }

}


Future<Position> getCurrentLocation() async {
  var _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  return _position ;
}


Future<bool> checkPermission() async {

  // 위치권한에 대한 서비스기능을 사용할 수 있는지 ?
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if(!isLocationEnabled){
    //return '위치 서비스를 활성화 해주세요';
    return false;
  }

  //현재 앱이 가지고있는 위치서비스에 대한 권한이 어떻게 되는지 가져온다.
  LocationPermission checkedPermission = await Geolocator.checkPermission();

  // 위치권한 denied 상태일때 (권한 허용이 안되었지만 요청은 할 수 있는 상태)
  if(checkedPermission == LocationPermission.denied){
    checkedPermission = await Geolocator.requestPermission(); // 권한 요청

    //권한 요청 후 또 다시 거부한 경우
    if(checkedPermission == LocationPermission.denied){
      // return '위치 권한을 허가해주세요';
      return false;
    }
  }

  // deniedForever상태인 경우 -> 기기 환경설정 위치설정에서 허가해주어야 함
  if(checkedPermission == LocationPermission.deniedForever) {
    // return '앱의 위치 권한을 기기 세팅에서 허가해주세요';
    return false;
  }

  // return '위치 권한이 허용되었습니다.';
  return true;
}
