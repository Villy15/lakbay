import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

class GeoCodingRepository {
  Future<Location> getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      return locations.first;
    } on Exception {
      rethrow;
    }
  }
}

final geoCodingRepositoryProvider = Provider((ref) {
  return GeoCodingRepository();
});
