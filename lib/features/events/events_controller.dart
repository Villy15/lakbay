// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/events/events_repository.dart';
import 'package:lakbay/models/event_model.dart';

final getAllEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final eventsController = ref.watch(eventsControllerProvider.notifier);
  return eventsController.getAllEvents();
});

final getEventsByCoopIdProvider =
    StreamProvider.autoDispose.family<List<EventModel>, String>((ref, uid) {
  final eventsController = ref.watch(eventsControllerProvider.notifier);
  return eventsController.getEventsByCoopId(uid);
});

final getEventsProvider =
    StreamProvider.autoDispose.family<EventModel, String>((ref, uid) {
  final coopsController = ref.watch(eventsControllerProvider.notifier);
  return coopsController.getEvent(uid);
});

final eventsControllerProvider =
    StateNotifierProvider<EventController, bool>((ref) {
  final eventsRepository = ref.watch(eventsRepositoryProvider);
  return EventController(
    eventsRepository: eventsRepository,
    ref: ref,
  );
});

class EventController extends StateNotifier<bool> {
  final EventsRepository _eventsRepository;
  final Ref _ref;

  EventController({
    required EventsRepository eventsRepository,
    required Ref ref,
  })  : _eventsRepository = eventsRepository,
        _ref = ref,
        super(false);

  Stream<List<EventModel>> getAllEvents() {
    return _eventsRepository.readEvents();
  }

  // Read all events by CoopID
  Stream<List<EventModel>> getEventsByCoopId(String coopId) {
    return _eventsRepository.readEventsByCoopId(coopId);
  }

  void addEvent(EventModel event, BuildContext context) async {
    final result = await _eventsRepository.addEvent(event);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (eventUid) {
        state = false;
        showSnackBar(context, 'Event added successfully');
        // context.pop();
        // _ref.read(navBarVisibilityProvider.notifier).show();
        context.pushReplacement("/my_coop/event/$eventUid");
      },
    );
  }

  void editEvent(EventModel event, BuildContext context) async {
    state = true;
    final result = await _eventsRepository.updateEvent(event);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (success) {
        state = false;
        showSnackBar(context, 'Event updated successfully');
        context.pop();
      },
    );
  }

  void joinEvent(String eventUid, String memberUid, BuildContext context,
      EventModel event) async {
    state = true;

    final result = await _eventsRepository.joinEvent(eventUid, memberUid);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (success) {
        state = false;
        showSnackBar(context, 'Joined the event successfully');
        context.pushReplacementNamed(
          'confirm_event',
          extra: event,
        );
      },
    );
  }

  void leaveEvent(
      String eventUid, String memberUid, BuildContext context) async {
    state = true;

    final result = await _eventsRepository.leaveEvent(eventUid, memberUid);

    result.fold(
      (failure) {
        state = false;
        showSnackBar(context, failure.message);
      },
      (success) {
        state = false;
        showSnackBar(context, 'Left the event successfully');
        context.pop();
      },
    );
  }

  Stream<EventModel> getEvent(String uid) {
    return _eventsRepository.readEvent(uid);
  }
}
