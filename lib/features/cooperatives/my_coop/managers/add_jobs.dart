import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class AddJobs extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final CooperativeModel coop;
  const AddJobs({super.key, required this.parentContext, required this.coop});

  @override
  ConsumerState<AddJobs> createState() => _AddJobsState();
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< STATE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
String? selectedCategory;
TextEditingController accommodationController = TextEditingController();
TextEditingController transportController = TextEditingController();
TextEditingController entertainmentController = TextEditingController();
TextEditingController touringController = TextEditingController();
TextEditingController foodController = TextEditingController();
List<Map> tourismTypes = [
  {
    "accommodation": {
      "title": "Accommodation",
      "controller": accommodationController,
      "active": false,
    }
  },
  {
    "transport": {
      "title": "Transport",
      "controller": transportController,
      "active": false
    }
  },
  {
    "entertainment": {
      "title": "Entertainment",
      "controller": entertainmentController,
      "active": false,
    }
  },
  {
    "touring": {
      "title": "Touring",
      "controller": touringController,
      "active": false,
    }
  },
  {
    "food": {
      "title": "Food",
      "controller": foodController,
      "active": false,
    }
  }
];
late Map<String, TourismJobs?>? tourismJobs;

class _AddJobsState extends ConsumerState<AddJobs> {
  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INITIALIZE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< FUNCTIONS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
    initCoop();
  }

  void initCoop() async {
    final CooperativeModel pulledCoop =
        await ref.read(getCooperativeProvider(widget.coop.uid!).future);
    tourismJobs = Map.from(pulledCoop.tourismJobs ?? {});
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    CooperativeModel updatedCoop =
        widget.coop.copyWith(tourismJobs: tourismJobs);
    ref
        .read(coopsControllerProvider.notifier)
        .updateCoop(updatedCoop.uid!, updatedCoop, context);
  }

  void handleJobAdd(String category, int index, List<Job> updatedJobList) {
    setState(() {
      tourismJobs?[category] =
          tourismJobs?[category]?.copyWith(jobs: updatedJobList) ??
              TourismJobs(jobs: updatedJobList);
    });
  }

  void handleJobRemove(String category, int index) {
    var updatedJobList = tourismJobs![category]!.jobs!.toList(growable: true);
    updatedJobList.removeAt(index);
    setState(() {
      tourismJobs![category] =
          tourismJobs![category]!.copyWith(jobs: updatedJobList);
    });
  }

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< RENDER UI >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  @override
  Widget build(BuildContext context) {
    debugPrint("$tourismJobs");
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Tourism Jobs'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(navBarVisibilityProvider.notifier).show();
              context.pop(widget.parentContext);
            },
          ),
        ),
        bottomNavigationBar: _bottomNavBar(context),
        body: _body(),
      ),
    );
  }

  Column addNotes(
    List<String> notes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DisplayText(
          text: "Guide:",
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
                      lines: 3,
                      style: Theme.of(context).textTheme.bodySmall!,
                    ),
                  ],
                ),
              );
            }))
      ],
    );
  }

  Form _body() {
    List<String> notes = [
      'Jobs indicated in this page would be the list of jobs applicant can select from when they attempt to join the cooperative.',
      // 'By default, the option "Member" is always available to all applicants regardless if indicated in this page.'
    ];
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
        child: Column(
          children: [
            addNotes(notes),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tourismTypes.length,
                itemBuilder: (context, index) {
                  final type = tourismTypes[index];
                  final String key = type.keys.first;
                  final String title = type[key]["title"];
                  bool active = type[key]["active"];
                  TextEditingController controller = type[key]["controller"];
                  final jobList =
                      tourismJobs?[key]?.jobs!.toList(growable: true) ?? [];
                  return Column(
                    children: [
                      ListTile(
                        title: active == false
                            ? Text(title)
                            : TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: title,
                                  border: const OutlineInputBorder(),
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .always, // Keep the label always visible
                                ),
                              ),
                        trailing: active == false
                            ? InkWell(
                                child: const Icon(Icons.add),
                                onTap: () {
                                  setState(() {
                                    tourismTypes[index][key]["active"] = true;
                                  });
                                },
                              )
                            : InkWell(
                                child: const Icon(Icons.check),
                                onTap: () {
                                  final Job newJob = Job(
                                      jobTitle: controller.text,
                                      searching: false);
                                  List<Job>? updatedJobList = jobList;
                                  updatedJobList.add(newJob);
                                  handleJobAdd(key, index, updatedJobList);
                                  setState(() {
                                    controller.clear();
                                    tourismTypes[index][key]["active"] = false;
                                  });
                                },
                              ),
                      ),
                      if (tourismJobs != {})
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jobList
                              .length, // Replace with the length of your data
                          itemBuilder: (context, index) {
                            final job = jobList[index];
                            return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 48),
                                dense: true,
                                leading: Text("[${index + 1}]"),
                                trailing: InkWell(
                                  child: const Icon(Icons.remove),
                                  onTap: () {
                                    handleJobRemove(key, index);
                                  },
                                ),
                                title: Text(job.jobTitle!));
                          },
                        )
                    ],
                  );
                }),
          ],
        ),
      )),
    );
  }

  BottomAppBar _bottomNavBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(120, 45)),
            ),
            onPressed: () {
              onSubmit();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
