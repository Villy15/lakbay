import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/listings/widgets/image_picker_form_field.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
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
                                      top: 10, bottom: 10, left: 20, right: 30),
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
                                ListView.builder(
                                    shrinkWrap: true,
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
                                                  : entry.value[index].status ==
                                                          'Completed'
                                                      ? const Icon(
                                                          Icons
                                                              .check_circle_outline,
                                                          color: Colors.green,
                                                          size: 25,
                                                        )
                                                      : entry.value[index]
                                                                  .status ==
                                                              'Incomplete'
                                                          ? const CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .grey, // Make the background transparent
                                                              radius: 11,
                                                              child: Icon(
                                                                Icons.circle,
                                                                color: Colors
                                                                    .white,
                                                                size:
                                                                    22, // Set the icon color
                                                              ),
                                                            )
                                                          : null, // Handle other conditions if needed
                                              subtitle: Text(
                                                  'Assigned: ${entry.value[index].assignedNames.join(', ')}'),
                                              trailing: IconButton(
                                                  onPressed: () {
                                                    showNotesDialog(context,
                                                        entry.value[index]);
                                                  },
                                                  icon: const Icon(
                                                      Icons.comment_outlined)),
                                              onTap: () {
                                                showTaskDialog(context, entry,
                                                    index, user);
                                              }),
                                        ],
                                      );
                                    })
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

  Future<dynamic> showNotesDialog(
      BuildContext context, BookingTask bookingTask) {
    List<BookingTaskMessage>? notes =
        bookingTask.notes?.toList(growable: true) ?? [];
    TextEditingController messageController = TextEditingController();
    notes.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text(
              'Notes',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            InkWell(
                onTap: () {
                  context.pop();
                },
                child: const Icon(
                  Icons.close,
                  size: 20,
                ))
          ]),
          content: SizedBox(
            height: MediaQuery.of(context).size.height /
                1.5, // Set a fixed height for the ListView
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, messageIndex) {
                      final message = notes[messageIndex];
                      return Container(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  message.senderName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(DateFormat('MMM d HH:mm')
                                    .format(message.timestamp)),
                              ],
                            ),
                            Text(message.content),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    10.0), // Adjust the border radius as needed
                color:
                    Colors.white, // Set the background color of the input field
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                      ),
                      maxLines: null, // Allow multiple lines
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      String content = messageController.text;
                      messageController.clear();
                      final user = ref.read(userProvider);
                      BookingTaskMessage message = BookingTaskMessage(
                          listingName: bookingTask.listingName,
                          senderId: user!.uid,
                          senderName: user.name,
                          taskId: bookingTask.uid!,
                          timestamp: DateTime.now(),
                          content: content);
                      notes.add(message);
                      BookingTask updatedBookingTask =
                          bookingTask.copyWith(notes: notes);

                      ref
                          .read(listingControllerProvider.notifier)
                          .updateBookingTask(context, bookingTask.listingId!,
                              updatedBookingTask, '');
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.deepOrange[400],
                    ), // Set the color of the send icon
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> showTaskDialog(BuildContext context,
      MapEntry<String, List<BookingTask>> entry, int index, UserModel user) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        List<File>? uploadImages = [];
        List<TaskImages>? sliderImages = entry.value[index].imageProof;
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
                if (sliderImages == null)
                  GestureDetector(
                    child: ImagePickerFormField(
                      height: MediaQuery.sizeOf(context).height / 3,
                      width: MediaQuery.sizeOf(context).width,
                      context: context,
                      initialValue: uploadImages,
                      onSaved: (List<File>? files) {
                        uploadImages = files;
                      },
                      validator: (List<File>? files) {
                        if (files == null || files.isEmpty) {
                          return 'Please select some images';
                        }
                        return null;
                      },
                      onImagesSelected: (List<File> files) {
                        uploadImages = files;
                      },
                    ),
                  )
                else
                  ImageSlider(
                      images: sliderImages.map((image) => image.url).toList(),
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
                            imageProof: uploadImages!.map((image) {
                              final imagePath =
                                  'listings/${currentCoop.cooperativeName}/${image.path.split('/').last}';
                              return TaskImages(
                                path: imagePath,
                              );
                            }).toList(),
                          );
                          final imagePath =
                              'listings/${currentCoop.cooperativeName}';
                          final ids = uploadImages!
                              .map((image) => image.path.split('/').last)
                              .toList();
                          ref
                              .read(storageRepositoryProvider)
                              .storeFiles(
                                path: imagePath,
                                ids: ids,
                                files: uploadImages!,
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
                      : entry.value[index].status == 'Completed'
                          ? const Text('Completed')
                          : const Text('Pending'))
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
