import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/google_map/google_map.dart';
import 'package:schedule_calendar/google_map/google_map_model.dart';
import 'package:schedule_calendar/google_map/kakao_api_model.dart';
import 'package:schedule_calendar/google_map/kakao_model.dart';
import 'package:schedule_calendar/model/schedule_model.dart';
import 'package:http/http.dart' as http;

enum Search { keyword, address }

class GoogleMapAddress extends StatefulWidget {


  var position;
  var mapData;

  GoogleMapAddress({
    required this.position,
    required this.mapData,
  });

  @override
  State<StatefulWidget> createState() {
    return _GoogleMapAddress();
  }
}

class _GoogleMapAddress extends State<GoogleMapAddress> {
  bool _isChecked = false;
  Search _search = Search.keyword;

  int selectedOption = 1;

  final contentController = TextEditingController();
  final dio = Dio();

 // late var position;

  late var focusLocation;

  var name="";
  late var address;


/*

  Future<Position> getCurrentLocation() async {
    checkPermission();
      //focusLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    var _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
*/
/*
    print(" !!!!!!!!! 1 11  ${position}");
    if(position == null ){
      print(" !!!!!!!!! if  ${position}");
      position = _position;
    }
    print(" !!!!!!!!!2222  ${position}");*//*


    return _position ;
  }

*/

  @override
  void initState() {
    super.initState();
    focusLocation = widget.position;
  }

  @override
  Widget build(BuildContext context) {

    print("!@!@!@ ${widget.position.latitude}  ${widget.position.longitude}");
    print("!@!!@  ${focusLocation.latitude}  ${focusLocation.longitude}");

   // focusLocation = LatLng(position!.latitude, position!.longitude);

    //print("googleMapAddress focusLocation ${focusLocation}");

    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context, widget.mapData);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child:  TextField(
                          controller: contentController,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '내용을 입력해주세요.',
                          ),
                          onSubmitted: (value){
                            getKeywordData();
                          }
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        getKeywordData();
                      },
                      onDoubleTap:() async {
                        getKeywordData();
                      },
                      child: Icon(
                        Icons.search,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('키워드'),
                        leading: Radio<int>(
                          value: 1,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('주소'),
                        leading: Radio<int>(
                          value: 2,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMapPage(lat: focusLocation.latitude, lng: focusLocation.longitude),
              ),


              Padding(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(name == ""){
                          showToast("위치를 검색해주세요.");
                        }else{
                          Navigator.pop(
                            context,
                            GoogleMapCheck(
                              isChecked: true,
                              googleMapData: GoogleMapData(
                                lat: focusLocation.latitude,
                                lng: focusLocation.longitude,
                                name: name,
                                formatted_address: address,
                              ),
                            ),

                          );
                        }

                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),



        ),
      ),
    );



  }

  Future<void> getKeywordData() async{
    var header = {
      'Authorization': 'KakaoAK 52109dafc4fdea8d693a1cfb2a51d9f3',
    };

    var list =[];

    try {

      int? pageableCount = 1;
      for(var i =0; i<3; i++) {

         var queryParameters = {
           "query": '${contentController.text}',
           "page" : '${i+1}',
         };

          final response = await http
              .get(Uri.https('dapi.kakao.com', '/v2/local/search/keyword.json',
              queryParameters), headers: header);

          if (response.statusCode == 200) {
            print(response.body);

            Map<String, dynamic> data = json.decode(response.body);
            KakaoApiModel model = KakaoApiModel.fromJson(data);

            print(" documents  ${model.documents}");
            print(" meta page count  ${model.meta?.pageableCount}");

            if(i == 0){
              print("0  ${pageableCount}");
              pageableCount = model.meta?.pageableCount;
            }

            print("1  ${pageableCount}");
            if( pageableCount != 0){
              for(var i=0; i<model.documents!.length; i++){
                print("2  ${pageableCount}");
                list.add(model.documents![i]);
                pageableCount!=null? pageableCount= pageableCount-1:null;
              }
            }else{
              break;
            }
          }
        }
      var count = list.length;
      if(count == 0) {
        showToast('검색 결과가 없습니다.');
      }else{
        FocusManager.instance.primaryFocus?.unfocus();
        kakaoApiDialog(list, context);
      }


    } on TimeoutException catch (_) {
      print('Time Out');
    }



   // var response = await dio.get(url);

    //var model = GoogleMapModel.fromJson(json: response.data );
/*
    var model = KakaoKeywordModel.fromJson(json: response.body)
    print("getKeywordData2  ${model.results}");

    var count = model.results == null? 0 : model.results?.length;
    if( count! > 0){
      FocusManager.instance.primaryFocus?.unfocus();
      dialog(model, context);
    }
*/


  }


  void kakaoApiDialog(dynamic list, BuildContext context){

    var count = list == null? 0 : list.length;

    print("count kakakoDialog  ${count}");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListView.separated(
          itemCount: count!,
          itemBuilder: (BuildContext context, int index){
            return Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    focusLocation = LatLng(
                        double.parse(list[index].y),
                      double.parse(list[index].x),
                    );
                    print("focus Location : ${focusLocation}");

                    name = list[index].placeName;
                    address = list[index].roadAddressName ==""
                        ? list[index].addressName
                        : list[index].roadAddressName;

                  });

                  Navigator.of(context).pop();
                },
                child: Column(
                  children: [
                    Text(
                      "${list[index].placeName}",
                      style: const TextStyle(
                          color: DARK_PRIMARY_COLOR,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "${list[index].roadAddressName ==""
                          ? list[index].addressName
                          : list[index].roadAddressName}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),



            );
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }



/*

  void dialog(dynamic list, BuildContext context){

    var count = list.results == null? 0 : list.results?.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListView.separated(
          itemCount: count!,
          itemBuilder: (BuildContext context, int index){
            return Container(
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    focusLocation = LatLng(
                        list.results![index].geometry!.location!.lat,
                        list.results![index].geometry!.location!.lng
                    );
                    print("focus Location : ${focusLocation}");

                    name = list.results![index].name;
                    address = list.results![index].formatted_address ?? "";

                  });

                  Navigator.of(context).pop();
                },
                child: Column(
                  children: [
                    Text(
                      "${list.results![index].name}",
                      style: const TextStyle(
                          color: DARK_PRIMARY_COLOR,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "${list.results![index].formatted_address}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

*/



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