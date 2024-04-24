
class GoogleMapModel {

  List<Map<String,dynamic>> html_attributions;

  List<Results>? results;

  GoogleMapModel({required this.results, required this.html_attributions});



  GoogleMapModel.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
        html_attributions = [],
        results =
        json['results'].map<Results>((i) => Results.fromJson(json: i)).toList();


  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['results'] = results;
    return data;
  }

}



class Results{
  final Geometry? geometry;
  final String? name;
  final String? formatted_address;

  Results({
    required this.geometry,
    required this.name,
    required this.formatted_address,
  });


  Results.fromJson({
    required Map<dynamic,dynamic> json,
  })  :
      geometry = json['geometry'] == null ? null : Geometry.fromJson(json: json['geometry']),
      name = json['name'],
      formatted_address = json['formatted_address'];


  Map<String, dynamic> toJson() {
    return {
      'geometry' : geometry,
      'name' : name,
      'formatted_address' : formatted_address,
    };
  }



}

class Geometry{

  final Location? location;

  Geometry({required this.location});

  Geometry.fromJson({
    required Map<String,dynamic> json,
  })  : location = json['location'] == null ? null : Location.fromJson(json: json['location']);

  Map<String, dynamic> toJson() {
    return {
      'location': location,
  };
  }
}

class Location {

  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });


  Location.fromJson({
    required Map<dynamic, dynamic> json,
  }):
        lat = json['lat'],
        lng = json['lng'];


  Map<String, dynamic> toJson(){
    return{
      'lat' : lat,
      'lng' : lng,
    };
  }

}




