import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/image_picker_form_field.dart';
import 'package:lakbay/features/tasks/tasks_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/task_model.dart';
import 'package:lakbay/models/user_model.dart';

class CoopTasksPage extends ConsumerStatefulWidget {
  const CoopTasksPage({super.key});

  @override
  ConsumerState<CoopTasksPage> createState() => _CoopTasksPageState();
}

class _CoopTasksPageState extends ConsumerState<CoopTasksPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Tasks')),
      body: ref.watch(getBookingTasksByMemberId(user!.uid)).when(
          data: (List<BookingTask>? bookingTasks) {
            Map<String, List<BookingTask>>? bookingTasksSorted = {};
            // // Build your list items here
            if (bookingTasks != null) {
              for (BookingTask task in bookingTasks) {
                if (bookingTasksSorted.containsKey(task.listingName)) {
                  bookingTasksSorted[task.listingName]!.add(task);
                } else {
                  bookingTasksSorted[task.listingName] = [task];
                }
              }
            }
            return bookingTasks!.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    // height: MediaQuery.sizeOf(context).height / 5,
                    width: double.infinity,
                    child: Column(
                      children: [
                        ...bookingTasksSorted.entries.map((entry) {
                          return ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 30),
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  width: double.infinity,
                                  color: Colors.grey[350],
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          '${entry.value.length}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height / 7.5,
                                  child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: entry.value.length,
                                      itemBuilder: (builder, index) {
                                        return Column(
                                          children: [
                                            ListTile(
                                                enabled: true,
                                                title: Text(
                                                  entry.value[index].name,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                leading: entry.value[index]
                                                            .status ==
                                                        'Pending'
                                                    ? const Text("Pending")
                                                    : entry.value[index]
                                                                .status ==
                                                            'Complete'
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                          )
                                                        : entry.value[index]
                                                                    .status ==
                                                                'Incomplete'
                                                            ? const CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .grey, // Make the background transparent
                                                                radius: 12.5,
                                                                child: Icon(
                                                                  Icons.circle,
                                                                  color: Colors
                                                                      .white,
                                                                  size:
                                                                      25, // Set the icon color
                                                                ),
                                                              )
                                                            : null, // Handle other conditions if needed

                                                onTap: () {
                                                  showTaskDialog(context, entry,
                                                      index, user);
                                                }),
                                          ],
                                        );
                                      }),
                                )
                              ],
                            ),
                          );
                        })
                      ],
                    ))
                : const Center(
                    child: Text(
                    "No Tasks Assigned",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
                  ));
          },
          error: (error, stackTrace) => ErrorText(
                error: error.toString(),
                stackTrace: '',
              ),
          loading: () => const CircularProgressIndicator()),
    );
  }

  Future<dynamic> showTaskDialog(BuildContext context,
      MapEntry<String, List<BookingTask>> entry, int index, UserModel user) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        dynamic images = entry.value[index].imageProof;
        List<String> notes = [
          'Uploaded images can serve as proof of for task accomplishment.'
        ];
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(entry.value[index].name),
            titleTextStyle: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w400, color: Colors.black),
            content: Column(
              children: [
                if (images == null)
                  GestureDetector(
                    child: ImagePickerFormField(
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: MediaQuery.sizeOf(context).width,
                      context: context,
                      initialValue: images,
                      onSaved: (List<File>? files) {
                        images = files;
                      },
                      validator: (List<File>? files) {
                        if (files == null || files.isEmpty) {
                          return 'Please select some images';
                        }
                        return null;
                      },
                      onImagesSelected: (List<File> files) {
                        images = files;
                      },
                    ),
                  )
                else
                  ImageSlider(
                      images: images.map((image) => image.url).toList(),
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: MediaQuery.sizeOf(context).width,
                      radius: BorderRadius.zero),
                addNotes(notes),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Back'),
              ),
              FilledButton(
                onPressed: entry.value[index].status == 'Incomplete'
                    ? () {
                        CooperativesJoined currentCoop =
                            user.cooperativesJoined!.firstWhere(
                          (element) =>
                              element.cooperativeId ==
                              user.currentCoop, // Return null if no matching element is found
                        );
                        BookingTask bookingTask = entry.value[index].copyWith(
                          imageProof: images!.map((image) {
                            final imagePath =
                                'listings/${currentCoop.cooperativeName}/${image.path.split('/').last}';
                            return TaskImages(
                              path: imagePath,
                            );
                          }).toList(),
                        );
                        final imagePath =
                            'listings/${currentCoop.cooperativeName}';
                        final ids = images!
                            .map((image) => image.path.split('/').last)
                            .toList();
                        ref
                            .read(storageRepositoryProvider)
                            .storeFiles(
                              path: imagePath,
                              ids: ids,
                              files: images!,
                            )
                            .then((value) => value.fold(
                                  (failure) => debugPrint(
                                      'Failed to upload images: $failure'),
                                  (imageUrls) async {
                                    bookingTask = bookingTask.copyWith(
                                        imageProof: bookingTask.imageProof!
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return entry.value.copyWith(
                                              url: imageUrls[entry.key]);
                                        }).toList(),
                                        status: 'Pending');
                                    debugPrint("$bookingTask");
                                    if (mounted) {
                                      ref
                                          .read(listingControllerProvider
                                              .notifier)
                                          .updateBookingTask(
                                              context,
                                              bookingTask.listingId!,
                                              bookingTask,
                                              'Task updated successfully!');
                                      context.pop();
                                    }
                                  },
                                ));
                      }
                    : null,
                child: entry.value[index].status == 'Incomplete'
                    ? const Text('Mark as Done')
                    : const Text('Pending'),
              )
            ],
          );
        });
      },
    );
  }

  Column addNotes(
    List<String> notes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        DisplayText(
          text: "Notes:",
          lines: 1,
          style: Theme.of(context).textTheme.headlineSmall!,
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notes.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    DisplayText(
                      text: notes[index],
                      lines: 10,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  ],
                ),
              );
            }))
      ],
    );
  }
}
