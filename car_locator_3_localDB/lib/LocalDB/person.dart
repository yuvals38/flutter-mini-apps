import 'package:geoflutterfire/geoflutterfire.dart';

class Person {
  String id;
  String name;
  double latitude;
  double longitude;
  GeoFirePoint position;
  String times;
  int visible;
  int counter;

  Person({this.id, this.name, this.position,this.times,this.visible});

  factory Person.fromMap(Map<String, dynamic> json) => new Person(
        id: json["id"],
        name: json["name"],
        position: json["position"],
        times: json["times"],
        visible: json["visible"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "position": position,
        "times": times,
        "visible" : visible,
      };
}