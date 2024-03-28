import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/location/map_repository.dart';

class CheckCurrentLocation extends ConsumerStatefulWidget {
  const CheckCurrentLocation({super.key});

  @override
  ConsumerState<CheckCurrentLocation> createState() => _CheckCurrentLocationState();
}

class _CheckCurrentLocationState extends ConsumerState<CheckCurrentLocation> {
  @override
  Widget build(BuildContext context) {
    final mapRepository = ref.read(mapRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        title: const Text('Check Current Location')
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            const Text('Check Current Location'),
            ElevatedButton(
              onPressed: () async {
                try {
                  final location = await mapRepository.getCoordinates('Manila');
                  debugPrint('Location: $location');
                } catch (e) {
                  debugPrint('Failed to get location: $e');
                }
              },
              child: const Text('Get Location')
            )
          ]
        )
      )
    );
  }
}