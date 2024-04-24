class KakaoApiModel {
  List<Documents>? documents;
  Meta? meta;

  KakaoApiModel({this.documents, this.meta});

  KakaoApiModel.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(new Documents.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }

}

class Documents {
  String? addressName;
  String? categoryGroupCode;
  String? categoryGroupName;
  String? categoryName;
  String? distance;
  String? id;
  String? phone;
  String? placeName;
  String? placeUrl;
  String? roadAddressName;
  String? x;
  String? y;

  Documents(
      {this.addressName,
        this.categoryGroupCode,
        this.categoryGroupName,
        this.categoryName,
        this.distance,
        this.id,
        this.phone,
        this.placeName,
        this.placeUrl,
        this.roadAddressName,
        this.x,
        this.y});

  Documents.fromJson(Map<String, dynamic> json) {
    addressName = json['address_name'];
    categoryGroupCode = json['category_group_code'];
    categoryGroupName = json['category_group_name'];
    categoryName = json['category_name'];
    distance = json['distance'];
    id = json['id'];
    phone = json['phone'];
    placeName = json['place_name'];
    placeUrl = json['place_url'];
    roadAddressName = json['road_address_name'];
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_name'] = this.addressName;
    data['category_group_code'] = this.categoryGroupCode;
    data['category_group_name'] = this.categoryGroupName;
    data['category_name'] = this.categoryName;
    data['distance'] = this.distance;
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['place_name'] = this.placeName;
    data['place_url'] = this.placeUrl;
    data['road_address_name'] = this.roadAddressName;
    data['x'] = this.x;
    data['y'] = this.y;
    return data;
  }
}




class Meta {
  bool? isEnd;
  int? pageableCount;
  //SameName? sameName;
  int? totalCount;

  Meta({this.isEnd, this.pageableCount, this.totalCount});

  Meta.fromJson(Map<String, dynamic> json) {
    isEnd = json['is_end'];
    pageableCount = json['pageable_count'];
    /*sameName = json['same_name'] != null
        ? new SameName.fromJson(json['same_name'])
        : null;*/
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_end'] = this.isEnd;
    data['pageable_count'] = this.pageableCount;
    /*if (this.sameName != null) {
      data['same_name'] = this.sameName!.toJson();
    }*/
    data['total_count'] = this.totalCount;
    return data;
  }
}



/*

class SameName {
  String? keyword;
  List<dynamic>? region;
  String? selectedRegion;

  SameName({this.keyword, this.region, this.selectedRegion});

  SameName.fromJson(Map<String, dynamic> json) {
    keyword = json['keyword'];
    region = json['region'];
    selectedRegion = json['selected_region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keyword'] = this.keyword;
    if (this.region != null) {
      data['region'] = this.region!.map((v) => v.toJson()).toList();
    }
    data['selected_region'] = this.selectedRegion;
    return data;
  }
}
*/
