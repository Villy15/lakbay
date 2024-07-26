import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatefulWidget {
  final String address;
  final bool? radius;
  const MapWidget({super.key, required this.address, this.radius});

  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  final StreamController<GoogleMapController> _mapController =
      StreamController<GoogleMapController>.broadcast();

  @override
  void initState() {
    super.initState();
    _mapController.stream.listen((GoogleMapController controller) {
      // do something with the controller
    });
  }

  @override
  void dispose() {
    _mapController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
      future: getLatLng(widget.address),
      builder: (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ClipRRect(
            borderRadius: widget.radius == true
                ? BorderRadius.circular(20)
                : BorderRadius.circular(0),
            child: GoogleMap(
              zoomControlsEnabled: false,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer())
              },
              markers: {
                Marker(
                  markerId: const MarkerId('marker_1'),
                  position: snapshot.data!,
                  // infoWindow: InfoWindow(
                  //   title: widget.address,
                  // ),
                ),
              },
              circles: {
                Circle(
                  circleId: const CircleId('circle_1'),
                  center: snapshot.data!,
                  radius: 10,
                  fillColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  strokeColor: Theme.of(context).colorScheme.primary,
                  strokeWidth: 1,
                ),
              },
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: snapshot.data!,
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController.add(controller);
              },
            ),
          );
        }
      },
    );
  }

  Future<LatLng> getLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      double latitude = locations.first.latitude;
      double longitude = locations.first.longitude;

      return LatLng(latitude, longitude);
    } catch (e) {
      return const LatLng(0, 0); // return a default value in case of error
    }
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}

class TwoMarkerMapWidget extends StatefulWidget {
  final String pickup;
  final String destination;
  final bool? radius;
  const TwoMarkerMapWidget(
      {super.key,
      required this.pickup,
      required this.destination,
      this.radius});

  @override
  State<TwoMarkerMapWidget> createState() => TwoMarkerMapWidgetState();
}

class TwoMarkerMapWidgetState extends State<TwoMarkerMapWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    Map<String, String> addresses = {};
    addresses['pickup'] = widget.pickup;
    addresses['destination'] = widget.destination;
    return FutureBuilder<Map<String, LatLng>>(
      future: getLatLng(addresses),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, LatLng>> snapshot) {
        LatLng? centerPoint;
        if (addresses['pickup']!.isNotEmpty &&
            addresses['destination']!.isNotEmpty) {
          if (snapshot.data != null) {
            centerPoint = LatLng(
              (snapshot.data!['pickup']!.latitude +
                      snapshot.data!['destination']!.latitude) /
                  2,
              (snapshot.data!['pickup']!.longitude +
                      snapshot.data!['destination']!.longitude) /
                  2,
            );
          }
        } else {
          centerPoint = snapshot.data!['pickup']!;
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ClipRRect(
            borderRadius: widget.radius == true
                ? BorderRadius.circular(20)
                : BorderRadius.circular(0),
            child: GoogleMap(
              zoomControlsEnabled: false,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer())
              },
              markers: {
                Marker(
                  markerId: const MarkerId('Pickup'),
                  position: snapshot.data!['pickup']!,
                  // infoWindow: InfoWindow(
                  //   title: widget.pickup,
                  // ),
                ),
                Marker(
                  markerId: const MarkerId('Destination'),
                  position: snapshot.data!['destination']!,
                  // infoWindow: InfoWindow(
                  //   title: widget.destination,
                  // ),
                ),
              },
              circles: {
                Circle(
                  circleId: const CircleId('pickup'),
                  center: snapshot.data!['pickup']!,
                  radius: 10,
                  fillColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  strokeColor: Theme.of(context).colorScheme.primary,
                  strokeWidth: 1,
                ),
                Circle(
                  circleId: const CircleId('destination'),
                  center: snapshot.data!['destination']!,
                  radius: 10,
                  fillColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  strokeColor: Theme.of(context).colorScheme.primary,
                  strokeWidth: 1,
                ),
              },
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: CameraPosition(
                target: centerPoint ?? const LatLng(0, 0),
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          );
        }
      },
    );
  }

  Future<Map<String, LatLng>> getLatLng(Map<String, String?> address) async {
    Map<String, LatLng> latlngs = {};
    for (var entry in address.entries) {
      var key = entry.key;
      var value = entry.value;
      try {
        if (value != null) {
          List<Location> locations = await locationFromAddress(value);
          double latitude = locations.first.latitude;
          double longitude = locations.first.longitude;
          latlngs[key] = LatLng(latitude, longitude);
        } else {
          latlngs[key] = const LatLng(0, 0);
        }
      } catch (e) {
        latlngs[key] = const LatLng(0, 0);
      }
    }
    return latlngs;
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
