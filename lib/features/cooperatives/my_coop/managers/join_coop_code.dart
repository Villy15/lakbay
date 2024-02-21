import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            break;
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

  void addMembers() {
    // Add members to the cooperative
    debugPrint('Adding members: ${extractedMembers.toString()}');
    final user = ref.read(userProvider);

    // Register members to firebase auth
    ref.read(authControllerProvider.notifier).registerMembers(
          context,
          extractedMembers,
          user?.currentCoop,
        );

    // Add members to the cooperative
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
    );
  }
}

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
  const MemberListTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${member.firstName} ${member.lastName}'),
      subtitle: Text(member.email),
    );
  }
}
