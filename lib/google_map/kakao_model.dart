
import 'dart:io';
/*
class KakaoKeywordModel {

  List<Place>? documents;        // 검색 결과

  KakaoKeywordModel({required this.documents});

  KakaoKeywordModel.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
        documents = json['documents'].map<Place>((i) => Place.fromJson(json: i)).toList();

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documents'] = documents;
    return data;
  }

}*/
/*

class Meta{
  bool is_end;
  int pageable_count;
  SameName sameName;


  Meta.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
        is_end=json['is_end'];
        pageable_count=json['pageable_count'];
        sameName=json['sameName'];

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['documents'] = documents;
    return data;
  }


}


class SameName{
  String keyword;
  List<dynamic> region;
  String selected_region;

}
*/

class Place{

  String id;
  String place_name;
  String category_name;
  String category_group_code;
  String category_group_name;
  String phone;
  String address_name;
  String road_address_name;
  String x;
  String y;
  String place_url;
  String distanc;


  Place({
    required this.id,
    required this.place_name,
    required this.category_name,
    required this.category_group_code,
    required this.category_group_name,
    required this.phone,
    required this.address_name,
    required this.road_address_name,
    required this.x,
    required this.y,
    required this.place_url,
    required this.distanc,
  });

  Place.fromJson({
    required Map<dynamic,dynamic> json,
  }) :
      id  = json['id'],
      place_name  = json['place_name'],
      category_name  = json['category_name'],
      category_group_code  = json['category_group_code'],
      category_group_name  = json['category_group_name'],
      phone  = json['phone'],
      address_name  = json['address_name'],
      road_address_name  = json['road_address_name'],
      x  = json['x'],
      y  = json['y'],
      place_url  = json['place_url'],
      distanc  = json['distanc'];



  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'place_name' : place_name,
      'category_name' : category_name,
      'category_group_code' : category_group_code,
      'category_group_name' : category_group_name,
      'phone' : phone,
      'address_name' : address_name,
      'road_address_name' : road_address_name,
      'x' : x,
      'y' : y,
      'place_url' : place_url,
      'distanc' : distanc,

    };
  }

}
