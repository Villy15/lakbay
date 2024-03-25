import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/widgets/map.dart';
import 'package:lakbay/features/location/map_repository.dart';

class SelectLocation extends ConsumerStatefulWidget {
  const SelectLocation({super.key});

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
                    ref.read(predictionsProvider.notifier).state = newPredictions;
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
                      // get the coordinates of the selected location
                      final location = await mapRepository.getCoordinates(predictions[index]);
                      debugPrint('location: $location');
                      // insert map widget here, then pass the location to it
                      //
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
