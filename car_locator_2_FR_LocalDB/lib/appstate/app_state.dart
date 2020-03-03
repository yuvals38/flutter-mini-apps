
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
  

  IconData icon1;// = Icons.pin_drop;

  AppState(bool fromuser) {
 
    getUserLocation();
    loadingInitialPosition(false);
    startQuery();

    //UpdateLocalDataMarkers();
  
  }
  ///////
  void recreateRoute(String transport) async{
    if (placemark.length > 0)
    {
      _polyLines.clear();
      LatLng latlngDestination = LatLng(placemark[0].position.latitude,placemark[0].position.longitude);
      LatLng latlngcurrentP = LatLng(_initialPosition.latitude,_initialPosition.longitude);
       String route = await _googleMapsServices.getRouteCoordinates(
          latlngcurrentP,latlngDestination,transport);
         

        createRoute(route);
       //notifyListeners();

    }
  }
  ///

// ! TO GET THE USERS LOCATION
  void getUserLocation() async {
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

  // ! TO CREATE ROUTE
  void createRoute(String encondedPoly) {
    RandomColor _randomColor = RandomColor();

    _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 10,
        points: _convertToLatLng(_decodePoly(encondedPoly)),
        color: _randomColor.randomColor()));//Colors.black));
    notifyListeners();
  }

  // ! ADD A MARKER ON THE MAO
  void addMarker(LatLng location,List<geolocator0.Placemark> placemarker,double distance,String dateT) {
    
    _markers.add(Marker(
        markerId: MarkerId(_lastPosition.toString()),
        position:  location,
        
        infoWindow: InfoWindow(title: placemarker[0].name.toString() + "\n" + placemarker[0].subLocality.toString()
        + "\n" + distance.toString(), snippet: placemarker[0].name.toString() + "\n" + placemarker[0].subLocality.toString()
        + "\n" + distance.toString()
        + "\n" + dateT),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)));

    icon1 = Icons.check_circle;

    
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
    icon1 = Icons.pin_drop;
    notifyListeners();
  }
//  LOADING INITIAL POSITION
  void loadingInitialPosition(bool fromshortcutMenu)async{
    try{

      addGeoPoint();
      addLocalDB();
      
      if(_initialPosition != null)
        sendRequest("${_initialPosition.latitude},${_initialPosition.longitude}", "walking",false);

      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
        
      }
    
    }
    catch(e)
    {
      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
      }
      //error
    }
  }

Location location = new Location();

var radius = BehaviorSubject<double>.seeded(3000.0);
Stream<dynamic> query;
StreamSubscription subscription;
List<DocumentSnapshot> userdata;
GeoPoint pos;

void UpdateLocalDataMarkers() async {
    //removeAllMarker();
    addLocalDB();
    //PersonDatabaseProvider.db.getAllPersonsList().asStream().length;
    Future<List<Person>> list = PersonDatabaseProvider.db.getAllPersons();
    list.then(
        // result here is the list of persons in the database
        (result) async{
            if (result.length >= 0) {
              List<Person> personlist = List<Person>();
              var count = result.length;
              for (int i = 0; i <= count-1; i++) {
                //add marker
                LatLng parkingloc = LatLng(result[i].latitude, result[i].longitude);
                List<geolocator0.Placemark> placemarking= await geolocator0.Geolocator().placemarkFromCoordinates(result[i].latitude, result[i].longitude);

                addMarker(parkingloc, placemarking,0.0,'');
                sendRequest("${result[i].latitude},${result[i].longitude}", "wakling",false);
                
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

                CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 90);
                this.mapController.animateCamera(u2).then((void v){
                check(u2,this._mapController);
                });
                notifyListeners();
              }}
              
            });
}

void updateMarkers(List<DocumentSnapshot> documentList)  {
    print(documentList);
    
    removeAllMarker();
 

    UpdateLocalDataMarkers();

    documentList.forEach((DocumentSnapshot document) async{
        pos = document.data['position']['geopoint'];
        double distance = document.data['distance'];
    
         LatLng parkingloc = LatLng(pos.latitude, pos.longitude);
         List<geolocator0.Placemark> placemarking= await geolocator0.Geolocator().placemarkFromCoordinates(pos.latitude, pos.longitude);

         addMarker(parkingloc, placemarking,distance,document.data['time']);
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

        CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 90);
        this.mapController.animateCamera(u2).then((void v){
        check(u2,this._mapController);
        });
        notifyListeners();
    });
  }

  void addLocalDB() async{
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm dd/MM/yy').format(now);
    var pos = await location.getLocation();
    //local db
    var person = await PersonDatabaseProvider.db.getPersonWithName('madeupname');

    if(person == null)
    {
      PersonDatabaseProvider.db.addPersonToDatabase(
        Person(id:1,name:'madeupname',latitude: pos.latitude,longitude: pos.longitude,times: formattedDate)
      );
    }

    //Future<List<Person>> snapshot  = PersonDatabaseProvider.db.getAllPersons();
  }

  Future<DocumentReference> addGeoPoint() async {

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm dd/MM/yy').format(now);
    var pos = await location.getLocation();
   
    //check data >0 
      await firestore
        .collection("locationtbl")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
          userdata = snapshot.documents;
        snapshot.documents.forEach((userdata) => print('${userdata.data}}'));
        });

        if(userdata.length == 0)
        {
          

            GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
            await firestore.collection('locationtbl').add({ 
              'position': point.data,
              'name': 'my name' ,
              'time' : formattedDate
            });
            
        }
        else{
          return null;
        }
  }
void deleteLocalData() async{
 //local db
      await PersonDatabaseProvider.db.deletePersonWithId(1);
      //PersonDatabaseProvider.db.deleteAllPersons();
}

void deleteData() async {
    try {
        //local db
      await PersonDatabaseProvider.db.deletePersonWithId(1);
      //PersonDatabaseProvider.db.deleteAllPersons();
      //firestore
  
      firestore.collection('locationtbl').getDocuments().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
           doc.reference.delete();}});
          
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
    var ref = firestore.collection('locationtbl');
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

   void deleteAllData() async {
    try {
      //local db
      PersonDatabaseProvider.db.deletePersonWithId(1);
      PersonDatabaseProvider.db.deleteAllPersons();
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
        await firestore.collection('locationtbl').getDocuments().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();}});

        //get loc
            geolocator0.Position position = await geolocator0.Geolocator()
              .getCurrentPosition(desiredAccuracy: geolocator0.LocationAccuracy.high);
  
            _initialPosition = LatLng(position.latitude, position.longitude);

        //add
            DateTime now = DateTime.now();
            String formattedDate = DateFormat('kk:mm dd/MM/yy').format(now);
            GeoFirePoint point = geo.point(latitude: _initialPosition.latitude, longitude: _initialPosition.longitude);
             await firestore.collection('locationtbl').add({ 
              'position': point.data,
              'name': 'my name' ,
              'time': formattedDate
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

