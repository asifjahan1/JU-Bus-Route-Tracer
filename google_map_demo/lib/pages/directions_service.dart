import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class DirectionsService {
  Future<void> getDirections() async {
    // Get user's location
    LocationData currentLocation = await Location().getLocation();
    double userLatitude = currentLocation.latitude!;
    double userLongitude = currentLocation.longitude!;

    // Construct API URL
    String apiEndpoint =
        'https://maps.googleapis.com/maps/api/directions/json?';
    String origin = 'origin=$userLatitude,$userLongitude';
    String destination = 'destination=Jahangirnagar University';
    String apiKey =
        'key=AIzaSyDNToFfTa1a7WqcxS1PlC382Oem1MpHeHA'; // Replace with your actual API key

    String apiUrl = '$apiEndpoint$origin&$destination&$apiKey';

    // Make API request
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Handle the successful response
      print('API response: ${response.body}');
      // Add your logic to process the API response here
    } else {
      // Handle the error response
      print('API request failed with status code: ${response.statusCode}');
    }
  }
}
