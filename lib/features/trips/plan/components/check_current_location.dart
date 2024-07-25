import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/location/map_repository.dart';

class CheckCurrentLocation extends ConsumerStatefulWidget {
  const CheckCurrentLocation({super.key});

  @override
  ConsumerState<CheckCurrentLocation> createState() =>
      _CheckCurrentLocationState();
}

class _CheckCurrentLocationState extends ConsumerState<CheckCurrentLocation> {
  @override
  Widget build(BuildContext context) {
    final mapRepository = ref.read(mapRepositoryProvider);
    // to store the longitude and latitude
    // store the address
    String address = '';
    return Scaffold(body:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: <Widget>[
            const Text('Check Current Location'),
            ElevatedButton(
                onPressed: () async {
                  final Position position = await _getCurrentLocation();
                  // print the latitude and longitude
                  debugPrint('latitude: ${position.latitude}');
                  debugPrint('longitude: ${position.longitude}');

                  // convert the longitude and latitude to address
                  final List<Placemark> placemarks =
                      await mapRepository.getAddressFromLatLng(
                          position.latitude, position.longitude);

                  // print the address
                  debugPrint('address: ${placemarks.first.street}');

                  // store the address
                  setState(() {
                    address = placemarks.first.street.toString();
                  });
                },
                child: const Text('Get Location')),
            // display the map widget
            const SizedBox(height: 10),
            SizedBox(
                height: 400, child: MapWidget(address: address, radius: true))
          ]));
    }));
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}
