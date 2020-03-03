import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
const apiKey = "AIzaSyB0erJwvorfDI3ZfanpNJ6NA5wrouUyDjo";

class GoogleMapsServices{
    Future<String> getRouteCoordinates(LatLng l1, LatLng l2, String transportation)async{
      String url ="";
      if(transportation == null)
      {
        url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
      }
      else
      {
         url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&mode=${transportation}&key=$apiKey";
      }
      http.Response response = await http.get(url);
      Map values = jsonDecode(response.body);
      return values["routes"][0]["overview_polyline"]["points"];
    }
}