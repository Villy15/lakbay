import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/location/map_repository.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';

class SelectLocation extends ConsumerStatefulWidget {
  // declare a string to indicate which page the user is in
  final String page;
  const SelectLocation({super.key, required this.page});

  @override
  ConsumerState<SelectLocation> createState() => _SelectLocationState();
}

final predictionsProvider = StateProvider<List<String>>((ref) => []);

class _SelectLocationState extends ConsumerState<SelectLocation> {
  @override
  Widget build(BuildContext context) {
    final mapRepository = ref.watch(mapRepositoryProvider);
    final predictions = ref.watch(predictionsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Select Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search for a location',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onChanged: (value) async {
                if (value.isNotEmpty) {
                  try {
                    final newPredictions =
                        await mapRepository.getPlacePredictions(value);
                    ref.read(predictionsProvider.notifier).state =
                        newPredictions;
                    debugPrint('predictions: $newPredictions');
                  } catch (e) {
                    debugPrint('Failed to load predictions: $e');
                  }
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  debugPrint('this is working!');
                  return ListTile(
                    title: Text(predictions[index]),
                    onTap: () async {
                      // if the user is in the plan page, set the location
                      switch (widget.page) {
                        case 'plan':
                          final planLocation =
                              ref.read(planLocationProvider.notifier);
                          planLocation.setLocation(predictions[index]);
                          break;
                        case 'listing':
                          final listingLocation =
                              ref.read(listingLocationProvider.notifier);
                          listingLocation.setLocation(predictions[index]);
                          break;
                        case 'destination':
                          final destinationLocation =
                              ref.read(destinationLocationProvider.notifier);
                          destinationLocation.setLocation(predictions[index]);
                          break;
                        case 'pickup':
                          final pickupPointLocation =
                              ref.read(pickupPointLocationProvider.notifier);
                          pickupPointLocation.setLocation(predictions[index]);
                          break;
                        default:
                          final planLocation =
                              ref.read(planLocationProvider.notifier);
                          planLocation.setLocation(predictions[index]);
                          break;
                      }
                      // ignore: use_build_context_synchronously
                      context.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
