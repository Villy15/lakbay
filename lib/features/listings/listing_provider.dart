import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/models/listing_model.dart';

final saveListingProvider =
    StateNotifierProvider<SaveListingProvider, ListingModel?>(
  (ref) => SaveListingProvider(),
);

class SaveListingProvider extends StateNotifier<ListingModel?> {
  SaveListingProvider() : super(null);

  void saveListingProvider(listing) {
    state = listing;
  }
}

final addRoomProvider =
    StateNotifierProvider<AddRoomProvider, List<AvailableRoom>?>(
  (ref) => AddRoomProvider(),
);

class AddRoomProvider extends StateNotifier<List<AvailableRoom>?> {
  AddRoomProvider() : super(null);

  void addRoom(room) {
    state = [...?state, room];
  }

  void removeRoom(index) {
    state?.removeAt(index);
  }
}

final addLocalImagesProvider =
    StateNotifierProvider<AddLocalImagesProvider, List<List<File>>?>(
  (ref) => AddLocalImagesProvider(),
);

class AddLocalImagesProvider extends StateNotifier<List<List<File>>?> {
  AddLocalImagesProvider() : super(null);

  void addImages(images) {
    state = [...?state, images];
  }
}
