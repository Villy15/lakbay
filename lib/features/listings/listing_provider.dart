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

final addTransportProvider =
    StateNotifierProvider<AddTransportProvider, List<AvailableTransport>?>(
  (ref) => AddTransportProvider(),
);

class AddTransportProvider extends StateNotifier<List<AvailableTransport>?> {
  AddTransportProvider() : super(null);

  void addTransport(transport) {
    state = [...?state, transport];
  }

  void removeTransport(index) {
    state?.removeAt(index);
  }
}

final addEntertainmentProvider =
    StateNotifierProvider<AddEntertainmentProvider, List<EntertainmentService>?>(
  (ref) => AddEntertainmentProvider(),
);

class AddEntertainmentProvider extends StateNotifier<List<EntertainmentService>?> {
  AddEntertainmentProvider() : super(null);

  void addEntertainment(entertainment) {
    state = [...?state, entertainment];
  }

  void removeEntertainment(index) {
    state?.removeAt(index);
  }
}

final addFoodProvider =
    StateNotifierProvider<AddFoodProvider, List<FoodService>?>(
  (ref) => AddFoodProvider(),
);

class AddFoodProvider extends StateNotifier<List<FoodService>?> {
  AddFoodProvider() : super(null);

  void addFood(food) {
    state = [...?state, food];
  }

  void removeFood(index) {
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
