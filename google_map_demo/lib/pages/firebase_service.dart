import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Example function to add data
  Future<void> addLocation(LatLng location) async {
    await _firestore.collection('locations').add({
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Example function to get data
  Stream<List<LatLng>> getLocations() {
    return _firestore.collection('locations').snapshots().map(
          (QuerySnapshot snapshot) => snapshot.docs.map(
            (DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return LatLng(data['latitude'], data['longitude']);
            },
          ).toList(),
        );
  }
}
