import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/providers/storage_repository_providers.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_member_roles_model.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/join_coop_params.dart';

class JoinCoopPage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  final bool? isMember;

  const JoinCoopPage({super.key, required this.coop, this.isMember});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _JoinCoopPageState();
}

class _JoinCoopPageState extends ConsumerState<JoinCoopPage> {
// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< STATE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final UserModel user;
  final _lastName = TextEditingController();
  final _firstName = TextEditingController();
  final _middleName = TextEditingController();
  DateTime? _birthDate;

  final _age = TextEditingController();
  final _gender = TextEditingController();
  final _religion = TextEditingController();
  final _nationality = TextEditingController();
  final _civilStatus = TextEditingController();

  TextEditingController committeeController = TextEditingController(text: "");
  TextEditingController jobController = TextEditingController(text: "");

  List<ReqFile> reqFiles = [];
  List<String?>? reqFilesList = [];
  List<File?>? documents = [];
  File? _validId;
  File? _birthCertificate;

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INITIALIZE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  // test values of member roles -> important ones being driver and tour guide for now
  List<String> availableMemberRoles = [
    'Driver',
    'Tour Guide',
    'Cooperative App Admin',
    'Conductor',
    'Accountant',
  ];
  final List<String> _selectedRoles = [];
  late Map<String, TourismJobs?>? tourismJobs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
    user = ref.read(userProvider)!;
    tourismJobs = widget.coop.tourismJobs;
  }

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< FUNCTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.

    super.dispose();
  }

  void joinCooperative() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    for (int i = 0; i < documents!.length; i++) {
      var file = documents![i];
      final String fileName = file!.path.split('/').last;
      final String path = "cooperatives/$fileName";
      await ref
          .read(storageRepositoryProvider)
          .storeFile(
            path: path,
            id: fileName,
            file: file,
          )
          .then((value) => value.fold(
                (failure) => debugPrint(
                  'Failed to upload file: $failure',
                ),
                (fileUrl) {
                  ReqFile reqFile = ReqFile(
                      fileName: fileName,
                      fileTitle: reqFilesList![i],
                      path: path,
                      url: fileUrl);
                  setState(() {
                    reqFiles.add(reqFile);
                  });
                },
              ));
    }

    var updatedCoop = widget.coop.copyWith(
      members: [...widget.coop.members, user.uid],
    );

    JoinCoopParams application = JoinCoopParams(
      coopId: updatedCoop.uid,
      name: user.name,
      userUid: user.uid,
      timestamp: DateTime.now(),
      age: user.age,
      gender: user.gender,
      religion: user.religion,
      nationality: user.nationality,
      civilStatus: user.civilStatus,
      committee: committeeController.text,
      role: jobController.text,
      status: "pending", //pending, rejected, completed
      reqFiles: reqFiles,
    );

    // Update user from the fields
    final updatedUser = user.copyWith(
      lastName: _lastName.text,
      firstName: _firstName.text,
      middleName: _middleName.text,
      birthDate: _birthDate,
      age: num.tryParse(_age.text),
      gender: _gender.text,
      religion: _religion.text,
      nationality: _nationality.text,
      civilStatus: _civilStatus.text,
    );

    final coopMemberRoles = CoopMemberRoles(
      coopId: widget.coop.uid!,
      memberId: user.uid,
      rolesSelected: _selectedRoles,
    );

    ref
        .read(coopsControllerProvider.notifier)
        .addApplication(updatedCoop.uid!, application, context);
    // ref
    //     .read(usersControllerProvider.notifier)
    //     .editProfileFromJoiningCoop(context, user.uid, updatedUser);
    // // Update coop
    // ref
    //     .read(coopsControllerProvider.notifier)
    //     .joinCooperative(updatedCoop, context);

    // // add it to the collection of member role
    // ref
    //     .read(coopMemberRolesControllerProvider.notifier)
    //     .addMemberRole(coopMemberRoles, context);
  }

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< RENDER UI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    final user = ref.watch(userProvider);

    // Initialize the controllers with the user's data
    if (user != null) {
      _lastName.text = user.lastName ?? '';
      _firstName.text = user.firstName ?? '';
    }
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Join Cooperative')),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Subtext
                          Text(
                            'This information will be given to the cooperative',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.6),
                            ),
                          ),

                          // const SizedBox(height: 20),
                          // _buildImage(context, userData),

                          const SizedBox(height: 20),
                          Text(
                            user!.name,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BiWeightText(
                                      title: "Gender: ", content: user.gender!),
                                  BiWeightText(
                                      title: "Birth Date: ",
                                      content: DateFormat('MMMM d, yyyy')
                                          .format(user.birthDate!)),
                                  BiWeightText(
                                      title: "Nationality: : ",
                                      content: user.nationality!),
                                  BiWeightText(
                                      title: "Civil Status: : ",
                                      content: user.civilStatus!),
                                  BiWeightText(
                                      title: "Religion: ",
                                      content: user.religion!),
                                ]),
                          ),

                          const SizedBox(height: 20),

                          const Text('Member Role',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),

                          Text('Please select the role you want to apply for',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6),
                              )),

                          const SizedBox(height: 10),
                          TextFormField(
                            controller: committeeController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                labelText: 'Tourism Committee',
                                border: OutlineInputBorder(),
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .always, // Keep the label always visible
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                hintText:
                                    "Press to select a committee" // Dropdown arrow icon
                                ),
                            readOnly: true,
                            canRequestFocus: false,
                            onTap: () async {
                              if (context.mounted) {
                                return showModalBottomSheet(
                                  context: context,
                                  builder: (builder) {
                                    return Container(
                                      padding: const EdgeInsets.all(
                                          10.0), // Padding for overall container
                                      child: Column(
                                        children: [
                                          // Optional: Add a title or header for the modal
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Text(
                                              "Tourism Committees",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  tourismJobs?.keys.length,
                                              itemBuilder: (context, keyIndex) {
                                                String? key = tourismJobs?.keys
                                                    .elementAt(keyIndex);
                                                return ListTile(
                                                  title: Text(
                                                    capitalize(key!),
                                                    style: const TextStyle(
                                                        fontSize:
                                                            16.0), // Adjust font size
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      committeeController.text =
                                                          capitalize(key);
                                                      context.pop();
                                                    });
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (committeeController.text != "")
                            TextFormField(
                              controller: jobController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  labelText: '${committeeController.text} Job',
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .always, // Keep the label always visible
                                  suffixIcon: const Icon(Icons.arrow_drop_down),
                                  hintText:
                                      "Press to select a job" // Dropdown arrow icon
                                  ),
                              readOnly: true,
                              canRequestFocus: false,
                              onTap: () async {
                                if (context.mounted) {
                                  return showModalBottomSheet(
                                    context: context,
                                    builder: (builder) {
                                      final committee = deCapitalize(
                                          committeeController.text);
                                      return Container(
                                        padding: const EdgeInsets.all(
                                            10.0), // Padding for overall container
                                        child: Column(
                                          children: [
                                            // Optional: Add a title or header for the modal
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              child: Text(
                                                "${committeeController.text} Jobs",
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount:
                                                    tourismJobs?[committee]
                                                        ?.jobs
                                                        ?.length,
                                                itemBuilder:
                                                    (context, jobIndex) {
                                                  Job job =
                                                      tourismJobs![committee]!
                                                          .jobs![jobIndex];
                                                  return ListTile(
                                                    title: Text(
                                                      job.jobTitle!,
                                                      style: const TextStyle(
                                                          fontSize:
                                                              16.0), // Adjust font size
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        jobController.text =
                                                            job.jobTitle!;
                                                        reqFilesList =
                                                            job.requiredFiles;
                                                      });
                                                      context.pop();
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),

                          const SizedBox(height: 20),
                          const Text(
                            'Documents',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Subtext
                          Text(
                            'Please provide the following documents.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.6),
                            ),
                          ),
                          // Valid IDs are as follow:
                          Text(
                            'Required Documents are as follows: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.6),
                            ),
                          ),

                          // Valid IDs
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: reqFilesList?.length,
                                  itemBuilder: (context, docIndex) {
                                    var doc = reqFilesList?[docIndex];
                                    var fileName = docIndex < documents!.length
                                        ? documents![docIndex]!
                                            .path
                                            .split('/')
                                            .last
                                        : "";
                                    return ListTile(
                                      leading: Text("${docIndex + 1}"),
                                      subtitle: fileName == ""
                                          ? null
                                          : Text(fileName),
                                      title: Text(doc?.toString() ?? ""),
                                      trailing: InkWell(
                                        onTap: () async {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: [
                                              'pdf'
                                            ], // specify the allowed extensions
                                          );

                                          if (result != null) {
                                            final File file =
                                                File(result.files.single.path!);
                                            setState(() {
                                              if (docIndex < reqFiles.length) {
                                                documents![docIndex] = file;
                                              } else {
                                                documents!.add(file);
                                              }
                                            });
                                          }
                                        },
                                        child: const Icon(
                                            Icons.file_copy_outlined),
                                      ),
                                    );
                                  })),

                          // Valid ID

                          // ListTile(
                          //   onTap: () async {
                          //     FilePickerResult? result =
                          //         await FilePicker.platform.pickFiles(
                          //       type: FileType.custom,
                          //       allowedExtensions: [
                          //         'pdf'
                          //       ], // specify the allowed extensions
                          //     );

                          //     if (result != null) {
                          //       final File file =
                          //           File(result.files.single.path!);
                          //       setState(() {
                          //         _validId = file;
                          //       });
                          //     }
                          //   },
                          //   title: const Text('Valid ID'),
                          //   subtitle: _validId != null
                          //       // File name
                          //       ? Text(
                          //           'PDF selected: ${_validId!.path.split('/').last}')
                          //       : const Text('Select a PDF file'),
                          //   trailing: const Icon(Icons.file_copy_outlined),
                          // ),

                          // Birth Certificate
                          // ListTile(
                          //   onTap: () async {
                          //     FilePickerResult? result =
                          //         await FilePicker.platform.pickFiles(
                          //       type: FileType.custom,
                          //       allowedExtensions: [
                          //         'pdf'
                          //       ], // specify the allowed extensions
                          //     );

                          //     if (result != null) {
                          //       setState(() {
                          //         _birthCertificate =
                          //             File(result.files.single.path!);
                          //       });
                          //     }
                          //   },
                          //   title: const Text('Birth Certificate'),
                          //   subtitle: _birthCertificate != null
                          //       ? Text(
                          //           'PDF selected: ${_birthCertificate!.path.split('/').last}')
                          //       : const Text('Select a PDF file'),
                          //   trailing: const Icon(Icons.file_copy_outlined),
                          // ),

                          const SizedBox(height: 10),

                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Card(
                          //     child: Padding(
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 16.0, vertical: 24.0),
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           const Text('Pay with',
                          //               style: TextStyle(
                          //                   fontSize: 20,
                          //                   fontWeight: FontWeight.bold)),
                          //           const SizedBox(height: 10),
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               SizedBox(
                          //                 width: 70, // specify the width
                          //                 height: 40, // specify the height
                          //                 child: Image.asset(
                          //                     "lib/core/images/paymaya.png"),
                          //               ),
                          //               Icon(Icons.payment,
                          //                   color: Theme.of(context)
                          //                       .colorScheme
                          //                       .primary),
                          //               // Add more payment method icons as needed
                          //             ],
                          //           ),

                          //           const SizedBox(height: 10),

                          //           // Payment Instructions
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               const Text('Total',
                          //                   style: TextStyle(
                          //                       fontSize: 20,
                          //                       fontWeight: FontWeight.bold)),
                          //               Text(
                          //                   '₱${widget.coop.membershipFee?.toStringAsFixed(2)}',
                          //                   style: const TextStyle(
                          //                       fontSize: 20,
                          //                       fontWeight: FontWeight.bold)),
                          //             ],
                          //           ),

                          //           // Details of Payment Label
                          //           const SizedBox(height: 10),
                          //           const Text('Details of Payment',
                          //               style: TextStyle(
                          //                   fontSize: 16,
                          //                   fontWeight: FontWeight.bold)),

                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               const Text("Membership Fee"),
                          //               Text(
                          //                   '₱${widget.coop.membershipFee?.toStringAsFixed(2)}'),
                          //             ],
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // const SizedBox(height: 20),

                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text(
                                    'By confirming below, you agree to our terms and conditions, and privacy policy.',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                      height: 20), // Add some spacing
                                  ElevatedButton(
                                    // Make it larger
                                    onPressed: () {
                                      joinCooperative();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      // Color
                                      backgroundColor: Colors.orange.shade700,
                                      minimumSize:
                                          const Size(double.infinity, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    // Color
                                    child: Text('Confirm and Join Cooperative',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            fontSize: 16)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
      ),
    );
  }

  // GestureDetector _buildImage(BuildContext context, UserModel userData) {
  //   return GestureDetector(
  //     child: Row(
  //       children: [
  //         Icon(Icons.image, color: Theme.of(context).iconTheme.color),
  //         const SizedBox(
  //             width: 15), // Add some spacing between the icon and the container
  //         Expanded(
  //           child: ImagePickerFormField(
  //             imageUrl: userData.profilePic,
  //             initialValue: _image,
  //             onSaved: (File? file) {
  //               _image = file;
  //             },
  //             // validator: (File? file) {
  //             //   if (file == null) {
  //             //     return 'Please select an image';
  //             //   }
  //             //   return null;
  //             // },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
