
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GeofireProvider {

  CollectionReference _ref;
  GeoFirestore _geo;


  GeofireProvider() {
    _ref = FirebaseFirestore.instance.collection('Locations');
    _geo =GeoFirestore(FirebaseFirestore.instance.collection('Locations'));
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getNearbyDrivers(double lat, double lng, double radius) {
    GeoPoint  center = GeoPoint(lat,lng);
    return _geo.getAtLocation(center,radius);


  }

  Stream<DocumentSnapshot> getLocationByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<void> create(String id, double lat, double lng) {
    GeoPoint myLocation =GeoPoint(lat,lng);
    print('====================crear $myLocation');
    return _ref.doc(id).set({'status': 'drivers_available', 'position':_geo.setLocation(id, myLocation) });
  }

  Future<void> createWorking(String id, double lat, double lng) {
    GeoPoint myLocation =GeoPoint(lat,lng);
    return _ref.doc(id).set({'status': 'drivers_working', 'position': myLocation});
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }

}