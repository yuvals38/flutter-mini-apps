
import 'package:car_locator_2/LocalDB/db_helper.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart' as geolocator0;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:car_locator_2/requests/google_maps_requests.dart';
import 'package:location/location.dart';
import 'package:random_color/random_color.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';
import 'package:car_locator_2/LocalDB/db_helper.dart';
import 'package:car_locator_2/LocalDB/person.dart';
import 'package:dio/dio.dart';
import 'package:car_locator_2/appstate/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';




const apiKey = "AIzaSyB0erJwvorfDI3ZfanpNJ6NA5wrouUyDjo";
class AppState with ChangeNotifier {
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  bool locationServiceActive = true;
  final Set<Marker> _markers = {};
 
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;

  static bool fromUserinput = false;
  //firestore
  final Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  
  //local database
  String transport = 'walking';
  IconData icon1;// = Icons.pin_drop;
  final List<Routes> routeslist = List<Routes>();
  bool createCustomRoute;
  String newtext = '';

  AppState(bool fromuser) {
    _getSharedPref();
    getUserLocation();
    loadingInitialPosition(false);
    addGeoPoint();
    //UpdateLocalDataMarkers();
    //1.step
    //startQuery();

  
  }

  String userID;
  _getSharedPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userID = (prefs.getString('uID'));

  }
  ///////
  void recreateRoute(String transport) async{
    try{
      if (placemark.length > 0)
      {
        _polyLines.clear();
        LatLng latlngDestination = LatLng(placemark[0].position.latitude,placemark[0].position.longitude);
        LatLng latlngcurrentP = LatLng(_initialPosition.latitude,_initialPosition.longitude);
        String route = await _googleMapsServices.getRouteCoordinates(
            latlngcurrentP,latlngDestination,transport);
          
          //routes.add(route);
          createRoute(route);
          //routes.forEach((item){
            //  createRoute(route);
          // });
        //notifyListeners();

      }
    }
    catch(e)
    {
      newtext = e.toString();
    }
  }
  ///

// ! TO GET THE USERS LOCATION
  void getUserLocation() async {
    try{
    print("GET USER METHOD RUNNING =========");
    geolocator0.Position position = await geolocator0.Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator0.LocationAccuracy.high);
    List<geolocator0.Placemark> placemark = await geolocator0.Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print("the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    locationController.text = placemark[0].name;
    //addGeoPoint();
    notifyListeners();
    }
    catch(e)
    {
      newtext = e.toString();
    }
  }

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    try{
      RandomColor _randomColor = RandomColor();
      if(createCustomRoute == null){createCustomRoute = false;}

      _polyLines.add(Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          width: 10,
          points: _convertToLatLng(_decodePoly(encondedPoly)),
          color: createCustomRoute ?_randomColor.randomColor(): Colors.black) );//Colors.black));
      notifyListeners();
    }
    catch(e)
    {
      newtext = e.toString();
    }
  }

 
  
  // ! ADD A MARKER ON THE MAO
  void addMarker(LatLng location,List<geolocator0.Placemark> placemarker,String distance,String duration,String dateT) {
    try{
      if(createCustomRoute == null){createCustomRoute = false;}
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position:  location,
        onTap: () {
            onclick(
        "Date: " + dateT + "\n" + placemarker[0].name.toString() + "\n" + placemarker[0].subLocality.toString()
        + "\nDistance: " + distance.toString()
        + "\nDuration: " + duration
        + "\n\n",location,_lastPosition.toString());
          },
        infoWindow: InfoWindow(title: placemarker[0].name.toString() + "\n" + placemarker[0].subLocality.toString()
        + "\n" + distance.toString(), snippet: placemarker[0].name.toString() + "\n" + placemarker[0].subLocality.toString()
        + "\n" + distance.toString()
        + "\n" + dateT),
        icon: createCustomRoute?BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen):
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)));
        
    icon1 = Icons.check_circle;

    
    notifyListeners();
    }
    catch(e)
    {
      newtext = e.toString();
    }
  }


  void CustomRoutes (LatLng location,String markerid)
  {
    try{
    if(routeslist.length == 0)
    {
      Routes localroute = Routes(markerid: markerid,latitudefirst: _initialPosition.latitude,longitudefirst:
       _initialPosition.longitude,latitudesecond: location.latitude,longitudesecond: location.longitude);
       routeslist.add(localroute);
    }
    else{
      double latitudeF = routeslist[routeslist.length-1].latitudesecond;
      double longitudeF = routeslist[routeslist.length-1].longitudesecond;

      Routes localroute = Routes(markerid: markerid,latitudefirst: latitudeF,longitudefirst:
       longitudeF,latitudesecond: location.latitude,longitudesecond: location.longitude);
       routeslist.add(localroute);
    }

    //loop routes:
    routeslist.forEach((item)async{
      LatLng firstpo = LatLng(item.latitudefirst,item.longitudefirst);
      LatLng secondpo = LatLng(item.latitudesecond,item.longitudesecond);

      String route = await _googleMapsServices.getRouteCoordinates(
          firstpo, secondpo, transport);

          createRoute(route);
            
          });
          notifyListeners();
    }
    catch(e)
    {
      newtext = e.toString();
    }
  }

  
  void onclick(String details,LatLng location,String markerid){

    newtext = details;
    if(createCustomRoute == true)
    {
     
      CustomRoutes(location,markerid);
      
      //routes.clear();

    }
    notifyListeners();
    
  }
  
  void clearRoutes()
  {
    _polyLines.clear();
    routeslist.clear();
    notifyListeners();
  }

  // ! CREATE LAGLNG LIST
  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  // !DECODE POLY
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }

  
  List<geolocator0.Placemark> placemark;
  double latitudeX;
  double longitudeY;
  // ! SEND REQUEST
  void sendRequest(String intendedLocation,String transportation,bool byaddress) async {

    try
    {

      LatLng destination;
      print(intendedLocation);
      if(byaddress == true)
      {
      placemark =
          await geolocator0.Geolocator().placemarkFromAddress(intendedLocation);
          latitudeX = placemark[0].position.latitude;
          longitudeY = placemark[0].position.longitude;
          destination = LatLng(latitudeX, longitudeY);
      }
      else{
          var splitter = intendedLocation.split(",");
          latitudeX =  double.parse(splitter[0]);
          longitudeY =  double.parse(splitter[1]);
          destination =  LatLng(latitudeX, longitudeY);
          
          placemark = await geolocator0.Geolocator().placemarkFromCoordinates(latitudeX,longitudeY);
          
          String route = await _googleMapsServices.getRouteCoordinates(
          _initialPosition, destination, transportation);

          createRoute(route);


      }

  
      notifyListeners();
    }
    catch(e)
    {
      print(e);
    }
    
  }

  

  void handleTap() {
   Share.share('https://www.google.com/maps/search/?api=1&query=${_initialPosition.latitude},${_initialPosition.longitude}');
 }


  // ! ON CAMERA MOVE
  void onCameraMove(CameraPosition position) async{

    _lastPosition = position.target;
    
    notifyListeners();
  }

void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
      check(u, c);
      notifyListeners();
  }

  // ! ON CREATE
  void onCreatedAndroid(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }


void removeAllMarker() {
    _markers.clear();
    _polyLines.clear();
    //routes.clear();
    icon1 = Icons.pin_drop;
    notifyListeners();
  }
//  LOADING INITIAL POSITION
  void loadingInitialPosition(bool fromshortcutMenu)async{
    try{

        //3. step
      //addGeoPoint();
     
      
      if(_initialPosition != null)
        sendRequest("${_initialPosition.latitude},${_initialPosition.longitude}", "walking",false);

      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
        
      }
    
    }
    catch(e)
      {
        newtext = e.toString();
      
      //error
      }
  }
int globalVisibility = 1;
bool firststart = true;
Location location = new Location();
int globalcounter;
var radius = BehaviorSubject<double>.seeded(3000.0);
Stream<dynamic> query;
StreamSubscription subscription;
List<DocumentSnapshot> userdata;
GeoPoint pos;
Dio dio = new Dio();
/*Future  UpdateLocalDataMarkers() async {
    //removeAllMarker();
    try{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm dd/MM/yy').format(now);
    var pos = await location.getLocation();
    List<geolocator0.Placemark> placemarking= await geolocator0.Geolocator().placemarkFromCoordinates(pos.latitude, pos.longitude);
   
    if(_initialPosition == null)
    {
        geolocator0.Position position = await geolocator0.Geolocator()
              .getCurrentPosition(desiredAccuracy: geolocator0.LocationAccuracy.high);
  
            _initialPosition = LatLng(position.latitude, position.longitude);
    }
    var person = await PersonDatabaseProvider.db.getPersonWithId(1);

    if (person == 0 || person == null)
    {
          Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${_initialPosition.latitude},${_initialPosition.longitude}&destinations=${pos.latitude},${pos.longitude}&mode=$transport&key=$apiKey");
          print(response.data);
          PersonDatabaseProvider.db.addPersonToDatabase(
          Person(id:1,name:'madeupname',latitude: pos.latitude,longitude: pos.longitude,times: formattedDate,visible: 1,counter: 1) 
          );
          LatLng parkingloc = LatLng(pos.latitude, pos.longitude);
          
          addMarker(parkingloc, placemarking,response.data["rows"][0]["elements"][0]["distance"]["text"],response.data["rows"][0]["elements"][0]["duration"]["text"],formattedDate);
          //adjust camera
          LatLng latLng_1 = LatLng(pos.latitude, pos.longitude);
          LatLng latLng_2 = LatLng(initialPosition.latitude, _initialPosition.longitude);
          LatLngBounds bound ;
          if(pos.latitude < initialPosition.latitude )
          {
            bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);
          }
          else{
            bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
          }
          //camera animate twice for android??
          CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 90);
          this.mapController.animateCamera(u2).then((void v){
          check(u2,this._mapController);
          });
          //---
          u2 = CameraUpdate.newLatLngBounds(bound, 90);
          this.mapController.animateCamera(u2).then((void v){
          check(u2,this._mapController);
          });
          ///show route only for last pin
          if(globalVisibility == 1){
          sendRequest("${pos.latitude},${pos.longitude}", "wakling",false);
          }
               
          notifyListeners();
        
    }
    else{
   //correct below
   if(firststart == true)
   {
     firststart = false;
     updateVisibilityData();
    var person = await PersonDatabaseProvider.db.getLastId();
      if(person != null)
      {
       if(person.visible != 1 ){
          globalcounter = person.id + 1;
        
          PersonDatabaseProvider.db.addPersonToDatabase(
          Person(id:globalcounter,name:'madeupname',latitude: pos.latitude,longitude: pos.longitude,times: formattedDate,visible: 1,counter: globalcounter) 
        );
       }
      }
   }
    Future<List<Person>> list = PersonDatabaseProvider.db.getAllPersons();
    
    list.then(
        // result here is the list of persons in the database
        (result) async{
            if (result.length >= 0) {
              //List<Person> personlist = List<Person>();
              var count = result.length;
              for (int i = 0; i <= count-1; i++) {
                //add marker
                //add new entry
                    
                   

                if(result[i].visible == globalVisibility || result[i].visible == 1){
                    //update counter
                    //globalcounter = result[i].counter + 1;

                    

                    LatLng parkingloc = LatLng(result[i].latitude, result[i].longitude);
                    List<geolocator0.Placemark> placemarking= await geolocator0.Geolocator().placemarkFromCoordinates(result[i].latitude, result[i].longitude);
                    Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${_initialPosition.latitude},${_initialPosition.longitude}&destinations=${result[i].latitude},${result[i].longitude}&mode=$transport&key=$apiKey");
                    print(response.data);
                    addMarker(parkingloc, placemarking,response.data["rows"][0]["elements"][0]["distance"]["text"],response.data["rows"][0]["elements"][0]["duration"]["text"],result[i].times);
                    
                    if(globalVisibility == 1){
                      //adjust camera
                      LatLng latLng_1 = LatLng(result[i].latitude, result[i].longitude);
                      LatLng latLng_2 = LatLng(initialPosition.latitude, _initialPosition.longitude);
                      LatLngBounds bound ;
                      if(result[i].latitude < initialPosition.latitude )
                      {
                        bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);
                      }
                      else{
                        bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
                      }

                      //camera animate twice android
                      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 90);
                      this.mapController.animateCamera(u2).then((void v){
                      check(u2,this._mapController);
                      });
                      //
                      u2 = CameraUpdate.newLatLngBounds(bound, 90);
                      this.mapController.animateCamera(u2).then((void v){
                      check(u2,this._mapController);
                      });
                      ///
                      
                        sendRequest("${result[i].latitude},${result[i].longitude}", "wakling",false);
                    }
                    notifyListeners();
                }
              }}
             
            });
             
    }
    //addGeoPoint();
    }
    catch(e)
    {
      print(e);
    }


}*/

void updateMarkers(List<DocumentSnapshot> documentList)  {
    print(documentList);
    
    //uncomment 2. step
    
 
    //UpdateLocalDataMarkers();
 

    documentList.forEach((DocumentSnapshot document) async{

        //if(document.data['id'] == userID || document.documentID == userID){
        if(document.data["shares"]["user1"] == userID){
             //removeAllMarker();
             if(_initialPosition == null)
              {
                  geolocator0.Position position = await geolocator0.Geolocator()
                        .getCurrentPosition(desiredAccuracy: geolocator0.LocationAccuracy.high);
            
                      _initialPosition = LatLng(position.latitude, position.longitude);
              }

          pos = document.data['position']['geopoint'];
          //double distance = document.data['distance'];
      
          LatLng parkingloc = LatLng(pos.latitude, pos.longitude);
          List<geolocator0.Placemark> placemarking= await geolocator0.Geolocator().placemarkFromCoordinates(pos.latitude, pos.longitude);
          
            Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${_initialPosition.latitude},${_initialPosition.longitude}&destinations=${pos.latitude},${pos.longitude}&mode=$transport&key=$apiKey");
                  print(response.data);

          addMarker(parkingloc, placemarking,response.data["rows"][0]["elements"][0]["distance"]["text"],response.data["rows"][0]["elements"][0]["duration"]["text"],document.data['time']);
          
          /*
          sendRequest("${pos.latitude},${pos.longitude}", "wakling",false);
          
          //adjust camera
          LatLng latLng_1 = LatLng(pos.latitude, pos.longitude);
          LatLng latLng_2 = LatLng(initialPosition.latitude, _initialPosition.longitude);
          LatLngBounds bound ;
          if(pos.latitude < initialPosition.latitude )
          {
            bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);
          }
          else{
            bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
          }
          ///camera animate twice android
          CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 90);
          this.mapController.animateCamera(u2).then((void v){
          check(u2,this._mapController);
          });

          u2 = CameraUpdate.newLatLngBounds(bound, 90);
          this.mapController.animateCamera(u2).then((void v){
          check(u2,this._mapController);
          });
          //
          */
          notifyListeners();
        }
       
    });

   
  }

  /*void addLocalDB() async{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm dd/MM/yy').format(now);
    var pos = await location.getLocation();
    //local db
    var person = await PersonDatabaseProvider.db.getPersonWithName('madeupname');

    if(person == null)
    {
      PersonDatabaseProvider.db.addPersonToDatabase(
        Person(id:1,name:'madeupname',latitude: pos.latitude,longitude: pos.longitude,times: formattedDate,visible: 1,counter: 1)
      );
    }
    else{
      PersonDatabaseProvider.db.deleteAllPersons();
      PersonDatabaseProvider.db.addPersonToDatabase(
        Person(id:1,name:'madeupname',latitude: pos.latitude,longitude: pos.longitude,times: formattedDate,visible: 1,counter: 1)
      );
    }

  }*/
  
  Future<DocumentReference> addGeoPoint() async {
    
    List<DocumentSnapshot> usershares;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> shares= new Map<String, List<String>>();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm dd/MM/yy').format(now);
    var pos = await location.getLocation();
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);

    if(_initialPosition == null)
        {
            geolocator0.Position position = await geolocator0.Geolocator()
                  .getCurrentPosition(desiredAccuracy: geolocator0.LocationAccuracy.high);
      
                _initialPosition = LatLng(position.latitude, position.longitude);
        }
    //check data >0 
       await firestore
        .collection("locationtbl")//.document(userID).get()
        .where("id",isEqualTo : userID )
        //.where("shares",arrayContains: )
        .getDocuments()
        .then((QuerySnapshot snapshot) {
          userdata = snapshot.documents;
        snapshot.documents.forEach((userdata) => print('${userdata.data}}'));
        });
        
        if(userdata == null || userdata.length == 0)
        {
              //add marker?
          LatLng parkingloc = LatLng(pos.latitude, pos.longitude);
          List<geolocator0.Placemark> placemarking= await geolocator0.Geolocator().placemarkFromCoordinates(pos.latitude, pos.longitude);
          
          Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${_initialPosition.latitude},${_initialPosition.longitude}&destinations=${pos.latitude},${pos.longitude}&mode=$transport&key=$apiKey");
                  print(response.data);

          addMarker(parkingloc, placemarking,response.data["rows"][0]["elements"][0]["distance"]["text"],response.data["rows"][0]["elements"][0]["duration"]["text"],formattedDate);
          sendRequest("${pos.latitude},${pos.longitude}", "wakling",false);
          
            //await prefs.setString('uID', userdata[0].documentID);
            /*Person person = new Person(
              id: userID,
              name: "user",
              position: geo.point(latitude: pos.latitude, longitude: pos.longitude),
              times: formattedDate,
              visible: 1,
            );*/

           // await firestore.document(userID).setData({
            //await firestore.document(userID).updateData(
           await firestore.collection('locationtbl').add({ 
              'id' : userID,
              'position': point.data,
              'name' : 'username',
              'time' : formattedDate,
              'visibile' : 1 ,
              'shares' : shares
              });
          
        
          //adjust camera
          /*LatLng latLng_1 = LatLng(pos.latitude, pos.longitude);
          LatLng latLng_2 = LatLng(initialPosition.latitude, _initialPosition.longitude);
          LatLngBounds bound ;
          if(pos.latitude < initialPosition.latitude )
          {
            bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);
          }
          else{
            bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
          }
          ///camera animate twice android
          CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 90);
          this.mapController.animateCamera(u2).then((void v){
          check(u2,this._mapController);
          });

          u2 = CameraUpdate.newLatLngBounds(bound, 90);
          this.mapController.animateCamera(u2).then((void v){
          check(u2,this._mapController);
          });*/
          //
          notifyListeners();
        }
        else{
          //add marker?
          LatLng parkingloc = LatLng(userdata[0].data["position"]["geopoint"].latitude, userdata[0].data["position"]["geopoint"].longitude);
          List<geolocator0.Placemark> placemarking= await geolocator0.Geolocator().placemarkFromCoordinates(userdata[0].data["position"]["geopoint"].latitude, userdata[0].data["position"]["geopoint"].longitude);
          
          Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${_initialPosition.latitude},${_initialPosition.longitude}&destinations=${userdata[0].data["position"]["geopoint"].latitude},${userdata[0].data["position"]["geopoint"].longitude}&mode=$transport&key=$apiKey");
                  print(response.data);

          addMarker(parkingloc, placemarking,response.data["rows"][0]["elements"][0]["distance"]["text"],response.data["rows"][0]["elements"][0]["duration"]["text"],formattedDate);
          sendRequest("${userdata[0].data["position"]["geopoint"].latitude},${userdata[0].data["position"]["geopoint"].longitude}", "wakling",false);
          
          //adjust camera
          LatLng latLng_1 = LatLng(userdata[0].data["position"]["geopoint"].latitude, userdata[0].data["position"]["geopoint"].longitude);
          LatLng latLng_2 = LatLng(initialPosition.latitude, _initialPosition.longitude);
          LatLngBounds bound ;
          if(userdata[0].data["position"]["geopoint"].latitude < initialPosition.latitude )
          {
            bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);
          }
          else{
            bound = LatLngBounds(southwest: latLng_2, northeast: latLng_1);
          }
          ///camera animate twice android
          CameraUpdate u2 =  CameraUpdate.newLatLngBounds(bound, 90);
          this.mapController.animateCamera(u2).then((void v){
          check(u2,this._mapController);
          });
          notifyListeners();


          //loop shares
          //userdata[0].data["shares"]
           /*
          await firestore
          .collection("locationtbl")//.document(userID).get()
          .where("id",isEqualTo : userdata[0].data["shares"]["user1"] )

         // .where("id",arrayContains: userdata[0].data["shares"]["user1"])
          .getDocuments()
          .then((QuerySnapshot snapshot) {
            usershares = snapshot.documents;
            snapshot.documents.forEach((usershares) => print('${usershares.data}}'));
          });

        if(usershares != null || usershares.length != 0)
        {
          LatLng parkinglocshares = LatLng(usershares[0].data["position"]["geopoint"].latitude, usershares[0].data["position"]["geopoint"].longitude);
          List<geolocator0.Placemark> placemarkingshares = await geolocator0.Geolocator().placemarkFromCoordinates(usershares[0].data["position"]["geopoint"].latitude, usershares[0].data["position"]["geopoint"].longitude);
          
          Response responseshares=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${_initialPosition.latitude},${_initialPosition.longitude}&destinations=${usershares[0].data["position"]["geopoint"].latitude},${usershares[0].data["position"]["geopoint"].longitude}&mode=$transport&key=$apiKey");
                  print(response.data);

          addMarker(parkinglocshares, placemarkingshares,response.data["rows"][0]["elements"][0]["distance"]["text"],response.data["rows"][0]["elements"][0]["duration"]["text"],formattedDate);
          sendRequest("${usershares[0].data["position"]["geopoint"].latitude},${usershares[0].data["position"]["geopoint"].longitude}", "wakling",false);
          
          //adjust camera
          LatLng latLng_1shares = LatLng(usershares[0].data["position"]["geopoint"].latitude, usershares[0].data["position"]["geopoint"].longitude);
          LatLng latLng_2shares = LatLng(initialPosition.latitude, _initialPosition.longitude);
          LatLngBounds boundshares ;
          if(usershares[0].data["position"]["geopoint"].latitude < initialPosition.latitude )
          {
            boundshares = LatLngBounds(southwest: latLng_1shares, northeast: latLng_2shares);
          }
          else{
            boundshares = LatLngBounds(southwest: latLng_2shares, northeast: latLng_1shares);
          }
          ///camera animate twice android
          CameraUpdate u2shares =  CameraUpdate.newLatLngBounds(boundshares, 90);
          this.mapController.animateCamera(u2shares).then((void v){
          check(u2shares,this._mapController);
          });

          ////////end of shares
          //u2 = CameraUpdate.newLatLngBounds(bound, 90);
          //this.mapController.animateCamera(u2).then((void v){
          //check(u2,this._mapController);
          //});
          //
          notifyListeners();
          
        }*/
         // userID = userdata[0].documentID;
         /*  await firestore
          .collection('locationtbl')
          .document(userdata[0].documentID)
          .updateData(
                {'position': point.data,
                'name': 'username' ,
                'time' : formattedDate,
                'visibile' : 1 ,
                'shares' : shares}
              );
           */
        }
  }
/*void deleteLocalData() async{
 //local db
      await PersonDatabaseProvider.db.deletePersonWithId(1);
      //PersonDatabaseProvider.db.deleteAllPersons();
}*/

void deleteData() async {
    try {
        //local db
    
      //PersonDatabaseProvider.db.deleteAllPersons();
      //firestore
  
     firestore.collection('locationtbl').getDocuments().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          if(doc.data['id'] == userID){
            doc.reference.delete();
            }
           }});
          
    } catch (e) {
      print(e.toString());
    }
  }

  startQuery() async {
    // Get users location
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    // Make a referece to firestore
    var ref = firestore.collection('locationtbl');//.where("id", isEqualTo: userID);//.where("shares/ID",arrayContains: userID);
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // subscribe to query
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center, 
        radius: rad, 
        field: 'position', 
        strictMode: true
      );
    }).listen(updateMarkers);
  }
 /* void updateVisibilityData() async{
    try{
        int lastid;
        var person = await PersonDatabaseProvider.db.getLastId();
        if(person != null)
        {
          lastid = person.id;
          PersonDatabaseProvider.db.updatePersonwithVisiblity(lastid);
        }
    }
    catch(e)
    {
        newtext = e.toString();
    }

  }*/
   void deleteAllData() async {
    try {
      //local db
      //PersonDatabaseProvider.db.deletePersonWithId(1);
      //PersonDatabaseProvider.db.deleteAllPersons();
      //firestore
       firestore.collection('locationtbl').getDocuments().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();}});

                
    } catch (e) {
      print(e.toString());
    }
  }

  
 Future<DocumentReference> addGeoPointAuto() async {
   
    try{
      //delete
       Map<String, List<String>> shares= new Map<String, List<String>>();
       // await firestore.collection('locationtbl').getDocuments().then((snapshot) {
        //for (DocumentSnapshot doc in snapshot.documents) {
         // doc.reference.delete();}});

        //get loc
            geolocator0.Position position = await geolocator0.Geolocator()
              .getCurrentPosition(desiredAccuracy: geolocator0.LocationAccuracy.high);
  
            _initialPosition = LatLng(position.latitude, position.longitude);

        //add
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('kk:mm dd/MM/yy').format(now);
            GeoFirePoint point = geo.point(latitude: _initialPosition.latitude, longitude: _initialPosition.longitude);
              await firestore.collection('locationtbl').add({ 
              'id' : userID,
              'position': point.data,
              'name' : 'username',
              'time' : formattedDate,
              'visibile' : 1 ,
              'shares' : shares
              });
       
    }
    catch(e){
      //log
    }
       
  }

  @override
  @mustCallSuper
  dispose() {
   
    subscription.cancel();
    super.dispose();
  }

}

