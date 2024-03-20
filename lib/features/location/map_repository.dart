import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class MapRepository {
  // calculate the travel time
  Future<String> calculateTravelTime(
      {required String origin, required String destination}) async {
    // call the google api to calculate the travel time
    var url =
        Uri.https('maps.googleapis.com', '/maps/api/distancematrix/json', {
      'origins': origin,
      'destinations': destination,
      'key': 'AIzaSyCZJI2SdZFSoFc_W3Ma9qWttKz_OVXe05I'
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint('response data: $data');
      var rows = data['rows'] as List;
      if (rows.isNotEmpty) {
        var elements = rows[0]['elements'] as List;
        if (elements.isNotEmpty) {
          var duration = elements[0]['duration']['text'];
          return duration;
        } else {
          throw Exception('No elements found');
        }
      } else {
        throw Exception('No rows found');
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }
}

final mapRepositoryProvider = Provider((ref) {
  debugPrint('yes yes yes');
  return MapRepository();
});
