// ignore_for_file: unused_local_variable

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/days_provider.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/crud/customer_food_checkout.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/features/trips/plan/plan_providers.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/models/user_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class FoodCard extends ConsumerStatefulWidget {
  final String category;
  final List<ListingModel>? foodListings;
  const FoodCard(
      {super.key, required this.category, required this.foodListings});

  @override
  FoodCardState createState() => FoodCardState();
}

class FoodCardState extends ConsumerState<FoodCard> {
  @override
  Widget build(BuildContext context) {
    final guests = ref.read(currentPlanGuestsProvider);
    final startDate = ref.read(planStartDateProvider);
    final endDate = ref.read(planEndDateProvider);
    final daysPlan = ref.read(daysPlanProvider);
    final currentUser = ref.read(userProvider);

    if (widget.foodListings != null) {
      return SizedBox(
          width: double.infinity,
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.foodListings!.length,
              itemBuilder: ((context, index) {
                final List<String?> imageUrls = widget
                    .foodListings![index].images!
                    .map((listingImage) => listingImage.url)
                    .toList();
                final food = widget.foodListings![index];
                return SizedBox(
                    width: MediaQuery.sizeOf(context).width / 2,
                    child: Card(
                        child: Column(children: [
                      ImageSlider(
                          images: imageUrls,
                          height: MediaQuery.sizeOf(context).height / 4,
                          width: MediaQuery.sizeOf(context).width / 2,
                          radius: BorderRadius.circular(10)),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10, top: 10, bottom: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(food.title,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(food.title,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(height: 10),
                                            Text(
                                              '₱${food.price.toString()} / reservation fee',
                                            )
                                          ])
                                    ]),
                                SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height / 30),
                                ref.watch(getListingProvider(food.uid!)).when(
                                    data: (ListingModel listing) {
                                      return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FilledButton(
                                                onPressed: () {
                                                  context.push(
                                                      '/market/${widget.category}',
                                                      extra: listing);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0), // Adjust the radius as needed
                                                  ),
                                                ),
                                                child: const Text(
                                                    'View Listing',
                                                    style: TextStyle(
                                                        fontSize: 14))),
                                            FilledButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0), // Adjust the radius as needed
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (currentUser?.name ==
                                                          'Lakbay User' ||
                                                      currentUser?.phoneNo ==
                                                          null ||
                                                      currentUser
                                                              ?.governmentId ==
                                                          null) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Profile Incomplete'),
                                                            content: const Text(
                                                                'To book a room, you need to complete your profile first.'),
                                                            actions: [
                                                              FilledButton(
                                                                onPressed:
                                                                    () async {
                                                                  showUpdateProfile(
                                                                      context,
                                                                      currentUser!);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.0), // Adjust the radius as needed
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  'Update Profile',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    showConfirmBooking(
                                                        food.availableDeals!
                                                            .first,
                                                        listing,
                                                        daysPlan.currentDay!);
                                                  }
                                                },
                                                child: const Text('Book Now'))
                                          ]);
                                    },
                                    error: (((error, stackTrace) => ErrorText(
                                        error: error.toString(),
                                        stackTrace: stackTrace.toString()))),
                                    loading: () => const Loader())
                              ])),
                    ])));
              })));
    } else {
      return Center(
          child: Column(children: [
        const Text('No Food Listings Available'),
        Text(
            "(${DateFormat('MMMM dd').format(startDate!)} - ${DateFormat('MMMM dd').format(endDate!)})")
      ]));
    }
  }

  void showConfirmBooking(
      FoodService food, ListingModel listing, DateTime bookedDate) {
    showDialog(
        context: context,
        builder: (context) {
          num guests = 0;
          final user = ref.read(userProvider);
          final currentPlanGuests = ref.read(currentPlanGuestsProvider);
          guests = currentPlanGuests!;

          TextEditingController guestsController =
              TextEditingController(text: guests.toString());
          TextEditingController phoneNoController =
              TextEditingController(text: user?.phoneNo);
          TextEditingController timeController =
              TextEditingController(text: '11:00 AM');
          bool governmentId = true;
          String formattedDate = DateFormat('MMMM dd, yyyy').format(bookedDate);

          return Dialog.fullscreen(
              child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBar(
                              leading: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    context.pop();
                                  }),
                              title: Text(formattedDate,
                                  style: const TextStyle(fontSize: 18)),
                              elevation: 0),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(children: [
                                TextFormField(
                                    controller: guestsController,
                                    decoration: const InputDecoration(
                                        labelText: 'Number of Guests',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: '12'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      guests = int.tryParse(value) ?? 0;
                                    }),
                                const SizedBox(height: 10),
                                TextFormField(
                                    controller: phoneNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always),
                                    keyboardType: TextInputType.phone),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: timeController,
                                  decoration: const InputDecoration(
                                      labelText: 'Time of Arrival',
                                      border: OutlineInputBorder(),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always),
                                  onTap: () async {
                                    showTimePicker(
                                            context: context,
                                            initialEntryMode:
                                                TimePickerEntryMode.inputOnly,
                                            initialTime: TimeOfDay.now())
                                        .then((time) {
                                      if (time != null) {
                                        // check if time is within the open hours / working time
                                        // compare time to the open hours
                                        debugPrint(
                                            'Opening Hour: ${listing.availableDeals!.first.startTime}');
                                        debugPrint(
                                            'Closing Hour: ${listing.availableDeals!.first.endTime}');

                                        debugPrint("User's chosen time: $time");
                                        // compare the hours and minutes of the time to start time and end time
                                        if (time.hour <
                                                listing.availableDeals!.first
                                                    .startTime.hour ||
                                            time.hour >
                                                listing.availableDeals!.first
                                                    .endTime.hour) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Invalid Time'),
                                                  content: const Text(
                                                      'The time you have chosen is not within the working hours of the listing.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                );
                                              });
                                          return;
                                        } else if (time.hour ==
                                                listing.availableDeals!.first
                                                    .startTime.hour &&
                                            time.minute <
                                                listing.availableDeals!.first
                                                    .startTime.minute) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Invalid Time'),
                                                  content: const Text(
                                                      'The time you have chosen is not within the working hours of the listing.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        child: const Text('OK'))
                                                  ],
                                                );
                                              });
                                          return;
                                        } else if (time.hour ==
                                                listing.availableDeals!.first
                                                    .endTime.hour &&
                                            time.minute >
                                                listing.availableDeals!.first
                                                    .endTime.minute) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Invalid Time'),
                                                content: const Text(
                                                    'The time you have chosen is not within the working hours of the listing.'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        context.pop();
                                                      },
                                                      child: const Text('OK'))
                                                ],
                                              );
                                            },
                                          );
                                          return;
                                        }
                                        setState(() {
                                          // set the time to the textfield
                                          timeController.text =
                                              time.format(context);

                                          // set bookedDate's time to the chosen time
                                          bookedDate = DateTime(
                                              bookedDate.year,
                                              bookedDate.month,
                                              bookedDate.day,
                                              time.hour,
                                              time.minute);
                                        });
                                      }
                                    });
                                  },
                                  readOnly: true,
                                ),
                                Column(children: [
                                  CheckboxListTile(
                                      enabled: false,
                                      value: governmentId,
                                      title: const Text('Government ID'),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          governmentId = value ?? false;
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: Text(
                                          'Your government ID is required as a means to protect cooperatives.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.italic)))
                                ]),
                                SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                        onPressed: () {
                                          context.pop();
                                          final currentTrip =
                                              ref.read(currentTripProvider);
                                          ListingBookings booking =
                                              ListingBookings(
                                            tripUid: currentTrip!.uid!,
                                            tripName: currentTrip.name,
                                            listingId: listing.uid!,
                                            listingTitle: listing.title,
                                            customerName:
                                                ref.read(userProvider)!.name,
                                            bookingStatus: "Reserved",
                                            price: food.price,
                                            category: 'Food',
                                            startDate: bookedDate,
                                            endDate: bookedDate,
                                            email: user?.email ?? '',
                                            governmentId:
                                                "https://firebasestorage.googleapis.com/v0/b/lakbay-cd97e.appspot.com/o/users%2FTimothy%20Mendoza%2Fimages%20(3).jpg?alt=media&token=36ab03ef-0880-4487-822e-1eb512a73ea0",
                                            guests: guests,
                                            customerPhoneNo:
                                                phoneNoController.text,
                                            customerId:
                                                ref.read(userProvider)!.uid,
                                            needsContributions: false,
                                            tasks: listing.fixedTasks,
                                          );

                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog.fullscreen(
                                                    child: CustomerFoodCheckout(
                                                        listing: listing,
                                                        foodService: food,
                                                        booking: booking));
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4.0)
                                          )
                                        ),
                                        child: const Text('Proceed')))
                              ]))
                        ])));
          }));
        });
  }

  Future<UserModel> submitUpdateProfile(
      BuildContext context,
      UserModel user,
      UserModel updatedUser,
      GlobalKey<FormState> formKey,
      File? profilePicture,
      File? governmentId) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (profilePicture != null) {
        final result = await ref.read(storageRepositoryProvider).storeFile(
              path: 'users/${updatedUser.name}',
              id: profilePicture.path.split('/').last,
              file: profilePicture,
            );

        result.fold((failure) => debugPrint('Failed to upload image: $failure'),
            (imageUrl) {
          // update user with the new profile picture
          updatedUser = updatedUser.copyWith(profilePic: imageUrl);
        });
      }

      if (governmentId != null) {
        final result = await ref.read(storageRepositoryProvider).storeFile(
              path: 'users/${updatedUser.name}',
              id: governmentId.path.split('/').last,
              file: governmentId,
            );

        result.fold((failure) => debugPrint('Failed to upload image: $failure'),
            (imageUrl) {
          // update user with the new government id picture
          updatedUser = updatedUser.copyWith(governmentId: imageUrl);
        });
      }

      // transfer updatedUser to user
      ref
          .read(usersControllerProvider.notifier)
          // ignore: use_build_context_synchronously
          .editProfile(context, user.uid, updatedUser);
    }

    return updatedUser;
  }

  void showUpdateProfile(BuildContext context, UserModel user) async {
    File? profilePicture;
    String? profilePicLink = user.profilePic;
    File? governmentId;
    // String? governmentIdLink = user.governmentId;
    ValueNotifier<File?> governmentIdNotifier = ValueNotifier<File?>(null);
    final TextEditingController firstNameController =
        TextEditingController(text: user.firstName ?? '');
    final TextEditingController lastNameController =
        TextEditingController(text: user.lastName ?? '');
    final TextEditingController phoneNoController =
        TextEditingController(text: user.phoneNo ?? '');
    final TextEditingController emailController =
        TextEditingController(text: user.email);
    final TextEditingController emergencyContactNameController =
        TextEditingController(text: user.emergencyContactName ?? '');
    final TextEditingController emergencyContactNoController =
        TextEditingController(text: user.emergencyContact ?? '');
    final TextEditingController addressController =
        TextEditingController(text: user.address ?? '');
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (context) {
          return Dialog.fullscreen(
              child: StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppBar(
                                leading: IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).pop()),
                                title: const Text('Edit Profile',
                                    style: TextStyle(fontSize: 18)),
                                elevation: 0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      child: Row(
                                    children: [
                                      Icon(Icons.image,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: ImagePickerFormField(
                                          imageUrl: profilePicLink,
                                          initialValue: profilePicture,
                                          onSaved: (value) {
                                            this.setState(() {
                                              profilePicture = value;
                                              debugPrint(
                                                  'this is the value: $profilePicture');
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  )),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          labelText: 'Email*',
                                          border: OutlineInputBorder(),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          hintText: "username@gmail.com",
                                          helperText: "*required"),
                                      keyboardType: TextInputType.emailAddress,
                                      // if email is not null, put the initial value
                                      onChanged: (value) {
                                        user = user.copyWith(email: value);
                                      },
                                      readOnly: true,
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: firstNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'First Name*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "First Name",
                                        helperText: "*required"),
                                    // put initial value if the user's first name is not null
                                    // initialValue: user.firstName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(firstName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: lastNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Last Name*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Last Name",
                                        helperText: "*required"),
                                    // initialValue: user.lastName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(lastName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                        labelText: 'Address*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Street, City, Province",
                                        helperText: "*required"),
                                    // initialValue: user.address ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(address: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: phoneNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Phone Number*',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        prefixText: "+63 ",
                                        helperText: "*required",
                                        hintText: '91234567891'),
                                    keyboardType: TextInputType.phone,
                                    // initialValue: user.phoneNo ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(phoneNo: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  // text for government id
                                  ListTile(
                                    title: const Text('Government ID*'),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                    subtitle: ValueListenableBuilder<File?>(
                                      valueListenable: governmentIdNotifier,
                                      builder: (context, governmentId, child) {
                                        return governmentId == null
                                            ? const Text(
                                                'Upload a valid Government ID ')
                                            : Text(
                                                'Government ID selected: ${path.basename(governmentId.path)}');
                                      },
                                    ),
                                    onTap: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'jpg',
                                          'jpeg',
                                          'png',
                                          'pdf',
                                          'doc'
                                        ],
                                      );

                                      if (result != null) {
                                        this.setState(() {
                                          governmentId =
                                              File(result.files.single.path!);
                                          governmentIdNotifier.value =
                                              governmentId;
                                        });
                                      }
                                    },
                                  ),

                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: emergencyContactNameController,
                                    decoration: const InputDecoration(
                                        labelText: 'Emergency Contact Name',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Lastname Firstname",
                                        helperText: "*required"),
                                    // initialValue: user.emergencyContactName ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(
                                          emergencyContactName: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: emergencyContactNoController,
                                    decoration: const InputDecoration(
                                        labelText: 'Emergency Contact Number',
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        prefixText: "+63 ",
                                        hintText: '91234567891',
                                        helperText: "*required"),
                                    keyboardType: TextInputType.phone,
                                    // initialValue: user.emergencyContactNo ?? '',
                                    onChanged: (value) {
                                      user = user.copyWith(
                                          emergencyContact: value);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  FilledButton(
                                    onPressed: () async {
                                      formKey.currentState!.save();
                                      UserModel updatedUser = user.copyWith(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        name:
                                            "${firstNameController.text} ${lastNameController.text}",
                                        address: addressController.text,
                                        phoneNo: phoneNoController.text,
                                        emergencyContactName:
                                            emergencyContactNameController.text,
                                        emergencyContact:
                                            emergencyContactNoController.text,
                                      );
                                      debugPrint(
                                          'this is the government id and the profile picture: $governmentId, $profilePicture');
                                      user = await submitUpdateProfile(
                                          context,
                                          user,
                                          updatedUser,
                                          formKey,
                                          profilePicture,
                                          governmentId);

                                      debugPrint('this is user: $user');

                                      // close dialog
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                      this.setState(() {
                                        user = user;
                                      });

                                      ref
                                          .read(userProvider.notifier)
                                          .setUser(user);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            4.0), // Adjust the radius as needed
                                      ),
                                    ),
                                    child: const Text(
                                        'Update Profile Information'),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    )));
          }));
        });
  }
}

class ImagePickerFormField extends FormField<File> {
  ImagePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    String? imageUrl,
  }) : super(
          builder: (FormFieldState<File> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      state.didChange(File(pickedFile.path));
                    }
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: state.value != null
                        ? Image.file(state.value!, fit: BoxFit.cover)
                        : (imageUrl != null && imageUrl.isNotEmpty)
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : const Center(child: Text('Select an image')),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 12),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}
