class Person {
  int id;
  String name;
  double latitude;
  double longitude;
  String times;

  Person({this.id, this.name, this.latitude,this.longitude,this.times});

  factory Person.fromMap(Map<String, dynamic> json) => new Person(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        times: json["times"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "times": times,
      };
}