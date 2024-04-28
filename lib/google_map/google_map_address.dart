import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:schedule_calendar/color/colors.dart';
import 'package:schedule_calendar/component/schedule_bottom_sheet.dart';
import 'package:schedule_calendar/google_map/google_map.dart';
import 'package:schedule_calendar/google_map/kakao_api_model.dart';
import 'package:schedule_calendar/model/schedule_model.dart';
import 'package:http/http.dart' as http;

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
  int selectedOption = 1;

  final contentController = TextEditingController();
  final dio = Dio();

  late var focusLocation;

  var name = "";
  late var address;

  @override
  void initState() {
    super.initState();
    focusLocation = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                      child: TextField(
                          controller: contentController,
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '키워드를 입력해주세요.',
                          ),
                          onSubmitted: (value) {
                            getKeywordData();
                          }),
                    ),
                    GestureDetector(
                      onTap: () async {
                        getKeywordData();
                      },
                      onDoubleTap: () async {
                        getKeywordData();
                      },
                      child: const Icon(
                        Icons.search,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMapPage(
                    lat: focusLocation.latitude, lng: focusLocation.longitude),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        child: const Center(
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
                      onTap: () {
                        if (name == "") {
                          showToast("위치를 검색해주세요.");
                        } else {
                          print("map call back address : ${name}");
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
                        child: const Center(
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

  Future<void> getKeywordData() async {
    var header = {
      'Authorization': 'KakaoAK 52109dafc4fdea8d693a1cfb2a51d9f3',
    };

    var list = [];

    try {
      int? pageableCount = 1;
      for (var i = 0; i < 3; i++) {
        var queryParameters = {
          "query": '${contentController.text}',
          "page": '${i + 1}',
        };

        final response = await http.get(
            Uri.https('dapi.kakao.com', '/v2/local/search/keyword.json',
                queryParameters),
            headers: header);

        if (response.statusCode == 200) {
          print(response.body);

          Map<String, dynamic> data = json.decode(response.body);
          KakaoApiModel model = KakaoApiModel.fromJson(data);

          print(" documents  ${model.documents}");
          if (i == 0) {
            pageableCount = model.meta?.pageableCount;
          }

          if (pageableCount != 0) {
            for (var i = 0; i < model.documents!.length; i++) {
              list.add(model.documents![i]);
              pageableCount != null ? pageableCount = pageableCount - 1 : null;
            }
          } else {
            break;
          }
        }
      }
      var count = list.length;
      if (count == 0) {
        showToast('검색 결과가 없습니다.');
      } else {
        FocusManager.instance.primaryFocus?.unfocus();
        kakaoApiDialog(list, context);
      }
    } on TimeoutException catch (_) {
      print('Time Out');
    }
  }

  void kakaoApiDialog(dynamic list, BuildContext context) {
    var count = list == null ? 0 : list.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              for (var index = 0; index < count; index++) ...[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      focusLocation = LatLng(
                        double.parse(list[index].y),
                        double.parse(list[index].x),
                      );
                      print("focus Location : ${focusLocation}");

                      name = list[index].placeName;
                      address = list[index].roadAddressName == ""
                          ? list[index].addressName
                          : list[index].roadAddressName;
                    });

                    Navigator.of(context).pop();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${list[index].placeName}",
                        style: const TextStyle(
                            color: DARK_PRIMARY_COLOR,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${list[index].roadAddressName == "" ? list[index].addressName : list[index].roadAddressName}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
