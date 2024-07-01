import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/models/coop_model.dart';

class JoinCoopCodePage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const JoinCoopCodePage({super.key, required this.coop});

  @override
  ConsumerState<JoinCoopCodePage> createState() => _JoinCoopCodePageState();
}

class _JoinCoopCodePageState extends ConsumerState<JoinCoopCodePage> {
  File? _csvFile; // Variable to store selected CSV
  List<MemberData> extractedMembers = []; // Store member info

  // Add a function to handle CSV file selection
  Future<void> _selectCSVFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result != null) {
        var bytes = File(result.files.single.path!).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);

        extractMemberData(excel); // Extract member data from Excel

        setState(() {
          _csvFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  // Function to process the Excel file and extract member information
  extractMemberData(excel) {
    extractedMembers.clear();
    for (var table in excel.tables.keys) {
      var rows = excel.tables[table]!.rows;
      debugPrint('Rows: ${rows.length}');

      // Check if there are more than one row to ensure headers exist
      if (rows.length > 1) {
        // Skip the first row (headers)
        for (var row in rows.skip(1)) {
          if (row.isNotEmpty && row[0] != null) {
            // if email is not a valid email, skip
            if (!row[0].value.toString().contains('@')) {
              continue;
            }

            extractedMembers.add(MemberData(
              email: row[0]?.value.toString() ?? '',
              password: row[1]?.value.toString() ?? '',
              firstName: row[2]?.value.toString() ?? '',
              lastName: row[3]?.value.toString() ?? '',
            ));

            // End loop after adding 1 member for testing
          }
        }
      }
    }
    debugPrint('Extracted members: ${extractedMembers.length}');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void addMembers() async {
    // Add members to the cooperative
    debugPrint('Adding members: ${extractedMembers.toString()}');
    final user = ref.read(userProvider);
    final firebase = ref.read(firestoreProvider);
    List<MemberData> newMembers = [];

    debugPrint('this is extracted members: $extractedMembers');

    // check if one of the extractedMembers is already registered in the application
    for (var member in extractedMembers) {
      final memberQuerySnapshot = await firebase
          .collection(FirebaseConstants.usersCollection)
          .where('email', isEqualTo: member.email)
          .get();
      if (memberQuerySnapshot.docs.isNotEmpty) {
        debugPrint('Member already exists: ${member.email}');
        debugPrint('Member data: ${memberQuerySnapshot.docs.first.data()}');
      } else {
        debugPrint('Member does not exist: ${member.email}');
        newMembers.add(member);
        debugPrint('New members: ${newMembers.toString()}');
      }
    }

    // check if the new members are stored
    debugPrint('New members are stored: ${newMembers.toString()}');

    try {
      if (newMembers.isEmpty) {
        debugPrint('there are no new members');
        showSnackBar(
            // ignore: use_build_context_synchronously
            context,
            'There are no new members to add. Please check the CSV file and update it or select a new file.');
        return;
      } else {
        ref.read(authControllerProvider.notifier).registerMembers(
              // ignore: use_build_context_synchronously
              context,
              newMembers,
              user?.currentCoop,
            );

        // send email to the new members
        sendEmail(newMembers, widget.coop);
        // ignore: use_build_context_synchronously
        context.pop();
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Members with CSV')),
        body: isLoading
            ? const Loader()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.upload_file,
                          size: 100,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Upload CSV File',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _csvFile != null
                            ? _csvFile!.path.split('/').last
                            : 'No file selected',
                      ),
                      const SizedBox(height: 20),
                      extractedMembers.isNotEmpty
                          ? const SizedBox.shrink()
                          : ElevatedButton(
                              onPressed: _selectCSVFile,
                              child: const Text('Select CSV File'),
                            ),
                      SizedBox(
                        height: 300,
                        child: extractedMembers.isNotEmpty
                            ? ListView.builder(
                                itemCount: extractedMembers.length,
                                itemBuilder: (context, index) => MemberListTile(
                                  member: extractedMembers[index],
                                  coop: widget.coop,
                                ),
                              )
                            : const Text('No members extracted yet'),
                      ),
                      const SizedBox(height: 20),
                      extractedMembers.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: _selectCSVFile,
                                  child: const Text('Reselect File'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    addMembers();
                                  },
                                  child: const Text('Add Members'),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// use the Google Cloud Function of sending email
Future<void> sendEmail(
    List<MemberData> newMembers, CooperativeModel coop) async {
  final response = await http.post(
    Uri.parse('https://us-central1-lakbay-cd97e.cloudfunctions.net/sendEmail'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'newMembers': newMembers
          .map((e) => {
                'email': e.email,
                'password': e.password,
                'firstName': e.firstName,
                'lastName': e.lastName
              })
          .toList(),
      'coop': coop.name,
    }),
  );

  if (response.statusCode == 200) {
    debugPrint('Email sent successfully');
  } else {
    debugPrint('these are the new members ${newMembers.toString()}');
    debugPrint('this is the coop name ${coop.name}');
    debugPrint('Failed to send email. Response: ${response.body}');
  }
}

// Future<void> sendEmail(
//     List<MemberData> newMembers, CooperativeModel coop, UserModel user) async {
//   final mailtoLink = Mailto(
//       to: newMembers.map((e) => e.email).toList(),
//       subject: 'Welcome to Lakbay!',
//       body: 'Hello there! \n\n'
//           'The ${coop.name} has partnered with Lakbay and its team for a better cooperative experience. \n\n'
//           'To login, make sure to use the following credentials: \n\n'
//           'Email: your current email (refer to the email that you received this message from) \n'
//           'Password: password \n\n'
//           'It is advised to reset your password after logging in to avoid any security issues. \n\n'
//           'If you have any questions or concerns, please do not hesitate to contact me. \n\n'
//           'Thank you for your cooperation and welcome to the Lakbay App! \n\n'
//           'Best regards, \n'
//           '${user.name} \n'
//           ' ${user.email}');

//   // ignore: deprecated_member_use
//   await launch('$mailtoLink');
// }

class MemberData {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  MemberData(
      {required this.email,
      required this.password,
      required this.firstName,
      required this.lastName});

  @override
  String toString() {
    return 'MemberData{email: $email, firstName: $firstName, lastName: $lastName}';
  }
}

class MemberListTile extends StatelessWidget {
  final MemberData member;
  final CooperativeModel coop;
  const MemberListTile({super.key, required this.member, required this.coop});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${member.firstName} ${member.lastName}'),
      trailing: IconButton(
        icon: const Icon(Icons.email),
        onPressed: () {
          // sendEmail(member.email, member.firstName, member.lastName, member.password, coop);
        },
      ),
      subtitle: Text(member.email),
    );
  }
}
