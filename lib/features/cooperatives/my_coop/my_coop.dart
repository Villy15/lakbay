import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/cooperatives/my_coop/components/announcement_card.dart';
import 'package:lakbay/features/cooperatives/my_coop/components/goal_card.dart';
import 'package:lakbay/features/events/widgets/event_card.dart';
import 'package:lakbay/features/listings/widgets/listing_card.dart';
import 'package:lakbay/features/notifications/notifications_controller.dart';
import 'package:lakbay/features/user/user_controller.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/event_model.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/notifications_model.dart';
import 'package:lakbay/models/subcollections/coop_announcements_model.dart';
import 'package:lakbay/models/subcollections/coop_goals_model.dart';
import 'package:lakbay/models/subcollections/coop_members_model.dart';
import 'package:lakbay/models/subcollections/coop_vote_model.dart';
import 'package:lakbay/models/user_model.dart';
import 'package:lakbay/models/wrappers/join_coop_params.dart';
import 'package:lakbay/payments/payment_with_paymaya.dart';

class MyCoopPage extends ConsumerStatefulWidget {
  final String coopId;
  const MyCoopPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyCoopPageState();
}

//PDF Config
String remotePdfPath = "";
final Completer<PDFViewController> controller = Completer<PDFViewController>();
int? totalPages = 0;
int? currentPage = 0;
bool isReady = false;
bool isPaid = false;

class _MyCoopPageState extends ConsumerState<MyCoopPage> {
  late List<CoopAnnouncements> coopAnnouncements;
  late List<CoopGoals> coopGoals;
  late List<CoopVote> coopVotes;
  late final UserModel user;
  CooperativeMembers? memberDetails;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider)!;
    _fetchMemberDetails(); 
    coopAnnouncements = [
      // CoopAnnouncements(
      //   title:
      //       'Cooperative Partners with [Coop_Name] Cooperative for Sustainable Tourism',
      //   description:
      //       'We\'re excited to announce a partnership with [Coop_Name] to promote eco-conscious travel practices. Get access to training resources, best practices, and potential funding.',
      //   timestamp: DateTime.now(),
      //   category: 'Sustainability',
      // ),

      // // New Announcement Examples:

      // CoopAnnouncements(
      //   title:
      //       'Experience the Flavors of [Region]: Culinary Festival Announced!',
      //   description:
      //       'Join us for a celebration of local cuisine on [dates]. Sample food from our member restaurants, attend cooking demonstrations, and enjoy live music!',
      //   timestamp: DateTime.now()
      //       .subtract(const Duration(days: 3)), // Set to a few days ago
      //   category: 'Event',
      // ),

      // CoopAnnouncements(
      //   title: 'Grant Program for Tourism Businesses Now Open',
      //   description:
      //       'The [program name] is accepting applications to support [types of projects]. Find eligibility details and the application deadline on [website]. ',
      //   timestamp: DateTime.now().subtract(const Duration(days: 1)),
      //   category: 'Funding',
      // ),

      // CoopAnnouncements(
      //   title: 'Member Spotlight: [Business Name] Wins Prestigious Award',
      //   description:
      //       'Congratulations to [Business Name] for their recognition at the [award name]! Their commitment to quality tourism strengthens our community.',
      //   timestamp: DateTime.now().subtract(const Duration(days: 5)),
      //   category: 'Member News',
      // ),
    ];

    coopGoals = [
      CoopGoals(
        title: 'Increase Overall Bookings',
        description:
            'Achieve a 10% increase in bookings across all categories within the next year.',
        targetDate: DateTime.now().add(const Duration(days: 365)),
        category: 'Economic Development',
        metrics: ['% increase in overall bookings'], // Adjust metrics as needed
        progress: 0.5, // Example progress
      ),
      CoopGoals(
        title: 'Boost Shoulder-Season Tourism',
        description:
            'Increase bookings during Q4 by 15% through targeted promotions and packages.',
        targetDate:
            DateTime(2024, 6, 30), // Example target within shoulder season
        category: 'Economic Development',
        metrics: [
          '% increase in shoulder-season bookings',
          'Number of promotions'
        ],
        progress: 0.3, // Example progress
      ),
      CoopGoals(
        title: 'Promote Multi-Offering Packages',
        description:
            'Develop and sell 5 new package deals that combine multiple cooperative offerings (e.g., lodging + tour + food experience), increasing average revenue per customer.',
        targetDate: DateTime(2023, 12, 31),
        category: 'Economic Development',
        metrics: [
          'Number of package deals created',
          'Average revenue per customer'
        ],
        progress: 0.7, // Example progress
      ),
    ];

    coopVotes = [
      CoopVote(
        position: 'Chairperson',
        dueDate: DateTime.now().add(const Duration(days: 30)),
      ),
      CoopVote(
        position: 'Sustainability Committee Head',
        dueDate: DateTime.now().add(const Duration(days: 30)),
      ),
      CoopVote(
        position: 'Marketing Committee Head',
        dueDate: DateTime.now().add(const Duration(days: 30)),
      ),
    ];
  }

  Future<void> _fetchMemberDetails() async {
    try {
      final member = await ref
          .read(getMemberProvider(user.uid).future);
      memberDetails = member;
      debugPrint('this is the member details: $memberDetails');
      setState(() {
        isPaid = memberDetails?.paidMembershipFee ?? false;
      });
    } catch (e) {
      debugPrint('Error fetching member details: $e');
    }
  }

  void viewMembers(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_members',
      extra: coop,
    );
  }

  void viewEvents(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'coop_events',
      extra: coop,
    );
  }

  void managerTools(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'manager_tools',
      extra: coop,
    );
  }

  void leaveCoop(BuildContext context, CooperativeModel coop) {
    context.pop();
    context.pushNamed(
      'leave_coop',
      extra: coop,
    );
  }

  List<Widget> tabs = [
    const SizedBox(
      width: 160.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_outlined),
            SizedBox(width: 4.0),
            Text('Announcements'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recommend a goals icon
            Icon(Icons.emoji_events_outlined),
            SizedBox(width: 4.0),
            Text('Goals'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recommend a election icon
            Icon(Icons.how_to_vote_outlined),
            SizedBox(width: 4.0),
            Text('Voting'),
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 150.0,
      child: Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recommend a election icon
            Icon(Icons.account_tree_rounded),
            SizedBox(width: 4.0),
            Text('Applications'),
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint('this is the payment status: ${memberDetails?.paidMembershipFee}');
    final user = ref.watch(userProvider);
    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            return DefaultTabController(
              initialIndex: 0,
              length: tabs.length,
              child: Scaffold(
                body: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      sliverAppBar(coop),
                      // sliverPaddingHeader(coop, user, context),

                      sliverAppBarHeaderWithTabs(coop, user, context),
                    ];
                  },
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TabBarView(
                      children: [
                        // Announcements
                        _coopAnnouncements(),

                        _coopGoals(),

                        _coopVotes(),

                        _coopApplications(coop.name),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorText(
              error: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          ),
          loading: () => const Scaffold(
            body: Loader(),
          ),
        );
  }

  Widget _coopVotes() {
    return ref.watch(getAllVotesProvider(widget.coopId)).when(
          data: (data) {
            if (data.isEmpty) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/core/images/SleepingCatFromGlitch.svg',
                        height: MediaQuery.sizeOf(context).height /
                            10, // Adjust height as desired
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No votes yet!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Check back later or create your own in the',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Manager Tools section.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final vote = data[index];

                return ListVote(vote: vote);
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
              error: error.toString(), stackTrace: stackTrace.toString()),
          loading: () => const Loader(),
        );
  }

  Widget _coopGoals() {
    return ref.watch(getAllGoalsProvider(widget.coopId)).when(
          data: (data) {
            if (data.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/core/images/SleepingCatFromGlitch.svg',

                        height: MediaQuery.sizeOf(context).height /
                            10, // Adjust height as desired
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No goals yet!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Set goals for your cooperative in the',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Manager Tools section.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final goal = data[index];

                return GoalCard(
                  goal: goal,
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
              error: error.toString(), stackTrace: stackTrace.toString()),
          loading: () => const Loader(),
        );
  }

  Widget _coopAnnouncements() {
    return ref.watch(getAllAnnouncementsProvider(widget.coopId)).when(
          data: (coopAnnouncements) {
            if (coopAnnouncements.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/core/images/SleepingCatFromGlitch.svg',
                        height: MediaQuery.sizeOf(context).height /
                            10, // Adjust height as desired
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No announcements yet!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Check back later or create your own in the',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Manager Tools section.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coopAnnouncements.length,
              itemBuilder: (context, index) {
                final announcement = coopAnnouncements[index];

                return AnnouncementCard(
                  announcement: announcement,
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
              error: error.toString(), stackTrace: stackTrace.toString()),
          loading: () => const Loader(),
        );
  }

  Widget _coopApplications(String coopName) {
    Query query = FirebaseFirestore.instance
        .collection("cooperatives")
        .doc(widget.coopId)
        .collection("applications")
        .where("status", isEqualTo: "pending");
    return ref.watch(getApplicationByProperties(query)).when(
          data: (applications) {
            if (applications.isEmpty) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/core/images/SleepingCatFromGlitch.svg',
                        height: MediaQuery.sizeOf(context).height /
                            10, // Adjust height as desired
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Applications yet!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applications.length,
              itemBuilder: (context, index) {
                final application = applications[index];

                return ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  title: Text(
                    application.name ?? 'No Application Name',
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(application.role!),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: const Icon(Icons.cancel_outlined, size: 20),
                          onTap: () {
                            onReject(context, application, coopName);
                          },
                        ),
                        InkWell(
                          child:
                              const Icon(Icons.check_circle_outlined, size: 20),
                          onTap: () {
                            onAccept(context, application, coopName);
                          },
                        ),
                        InkWell(
                          child: const Icon(Icons.file_open_outlined, size: 20),
                          onTap: () {
                            onViewApplication(context, application);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(
              error: error.toString(), stackTrace: stackTrace.toString()),
          loading: () => const Loader(),
        );
  }

  Future<dynamic> onViewApplication(
      BuildContext context, JoinCoopParams application) {
    return showDialog(
        context: context,
        barrierDismissible: false, // User must tap button to close the dialog
        builder: (BuildContext context) {
          return Dialog.fullscreen(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        iconSize: 30,
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Application Details',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
                    Text(
                      application.name!,
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
                                title: "Age: ",
                                content: application.age!.toString()),
                            BiWeightText(
                                title: "Nationality: : ",
                                content: application.nationality!),
                            BiWeightText(
                                title: "Civil Status: : ",
                                content: application.civilStatus!),
                            BiWeightText(
                                title: "Religion: ",
                                content: application.religion!),
                          ]),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Applying",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    ListTile(
                      title: Text(application.role!),
                      subtitle: Text(application.committee!),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Documents",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: application.reqFiles!.length,
                        itemBuilder: (context, index) {
                          var file = application.reqFiles![index];
                          return ListTile(
                            title: Text(file.fileTitle!),
                            subtitle: Text(file.fileName!),
                            trailing: const InkWell(
                                child: Icon(Icons.file_open_outlined)),
                            onTap: () {
                              String? pdfPath;

                              createFileOfPdfUrl(file.url!).then((value) {
                                pdfPath = value.path;
                                setState(() {
                                  remotePdfPath = value.path;
                                });
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog.fullscreen(
                                        child: PDFView(
                                          filePath: pdfPath,
                                          swipeHorizontal: true,
                                          enableSwipe: true,
                                          autoSpacing: false,
                                          pageFling: true,
                                          pageSnap: true,
                                          defaultPage: currentPage!,
                                          fitPolicy: FitPolicy.BOTH,
                                          preventLinkNavigation:
                                              false, // if set to true the link is handled in flutter
                                          onRender: (pages) {
                                            setState(() {
                                              totalPages = pages;
                                              isReady = true;
                                            });
                                          },
                                          onViewCreated: (PDFViewController
                                              pdfViewController) {
                                            controller
                                                .complete(pdfViewController);
                                          },
                                          onPageChanged:
                                              (int? page, int? total) {
                                            setState(() {
                                              currentPage = page;
                                            });
                                          },
                                        ),
                                      );
                                    });
                              });
                            },
                          );
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> onAccept(
      BuildContext context, JoinCoopParams application, String coopName) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve'),
        content: const Text('Do you want to approve this application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              JoinCoopParams updatedApplication = application;
              updatedApplication =
                  updatedApplication.copyWith(status: "accepted");
              CooperativeMembersRole memberRole = CooperativeMembersRole(
                  role: updatedApplication.role,
                  committeeName: updatedApplication.committee,
                  timestamp: DateTime.now());
              CooperativeMembers newMember = CooperativeMembers(
                  uid: application.userUid!,
                  name: updatedApplication.name!,
                  committees: [memberRole],
                  isManager: false,
                  timestamp: DateTime.now(),
                  paidMembershipFee: false
                  );

              NotificationsModel acceptedCoopNotif = NotificationsModel(
                  title: 'Application Accepted!',
                  message:
                      'Your application to join $coopName has been accepted!',
                  ownerId: application.userUid,
                  coopId: widget.coopId,
                  isToAllMembers: false,
                  type: 'coop',
                  createdAt: DateTime.now(),
                  isRead: false);
              ref
                  .read(coopsControllerProvider.notifier)
                  .editApplication(updatedApplication, context);
              ref
                  .read(coopsControllerProvider.notifier)
                  .addMember(updatedApplication.coopId!, newMember, context);

              ref
                  .read(coopsControllerProvider.notifier)
                  .addMemberUidOnMembersList(
                      updatedApplication.coopId!, updatedApplication.userUid!);

              final user = await ref
                  .read(getUserDataProvider(application.userUid!).future);

              final newUser = user.copyWith(
                cooperativesJoined: [
                  ...user.cooperativesJoined ?? [],
                  CooperativesJoined(
                    cooperativeId: updatedApplication.coopId!,
                    role: "Member",
                    cooperativeName: coopName,
                  ),
                ],
                currentCoop: updatedApplication.coopId!,
              );

              ref
                  .read(usersControllerProvider.notifier)
                  .editUserAfterJoinCoopCoopsJoined(
                      application.userUid!, newUser);

              if (context.mounted) {
                ref
                    .read(notificationControllerProvider.notifier)
                    .addNotification(acceptedCoopNotif, context);

                context.pop();
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> onReject(
    BuildContext context, JoinCoopParams application, String coopName) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reject'),
      content: const Text('Do you want to reject this application?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () async {
            // Show a dialog to enter the reason for rejection
            String? reason = await showDialog<String>(
              context: context,
              builder: (context) {
                String input = '';
                return AlertDialog(
                  title: const Text('Enter Reason'),
                  content: TextField(
                    onChanged: (value) {
                      input = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Reason for rejection',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, input),
                      child: const Text('Submit'),
                    ),
                  ],
                );
              },
            );

            if (reason != null && reason.isNotEmpty) {
              JoinCoopParams updatedApplication = application;
              NotificationsModel rejectCoopNotif = NotificationsModel(
                title: 'Application Rejected!',
                message: "Your application to join $coopName has been rejected! The reason:\n$reason.",
                ownerId: application.userUid,
                coopId: widget.coopId,
                isToAllMembers: false,
                type: 'coop',
                createdAt: DateTime.now(),
                isRead: false,
              );
              updatedApplication =
                  updatedApplication.copyWith(status: "rejected");
              ref
                  .read(coopsControllerProvider.notifier)
                  // ignore: use_build_context_synchronously
                  .editApplication(updatedApplication, context);

              ref
                  .read(notificationControllerProvider.notifier)
                  // ignore: use_build_context_synchronously
                  .addNotification(rejectCoopNotif, context);

              // ignore: use_build_context_synchronously
              context.pop();
            }
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}

  // Build Events
  Widget buildListViewEvents(AsyncValue<List<EventModel>> events) {
    return events.when(
      data: (data) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final event = data[index];
            return EventCard(event: event);
          },
        );
      },
      error: (error, stackTrace) =>
          ErrorText(error: error.toString(), stackTrace: stackTrace.toString()),
      loading: () => const Scaffold(
        body: Loader(),
      ),
    );
  }

  Widget buildListViewListings(AsyncValue<List<ListingModel>> listings) {
    return listings.when(
      data: (data) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final listing = data[index];
            return ListingCard(
              listing: listing,
            );
          },
        );
      },
      error: (error, stackTrace) =>
          ErrorText(error: error.toString(), stackTrace: stackTrace.toString()),
      loading: () => const Scaffold(
        body: Loader(),
      ),
    );
  }

  SliverAppBar sliverAppBarHeaderWithTabs(
      CooperativeModel coop, UserModel? user, BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.sizeOf(context).height / 2.5,
      pinned: true,
      collapsedHeight: kToolbarHeight,
      floating: true,
      snap: true,
      actions: const [
        Icon(Icons.search, color: Colors.transparent),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      coop.imageUrl!,
                    ),
                    radius: 35,
                  ),
                  Row(
                    children: [
                      coop.managers.contains(user?.uid)
                          ? OutlinedButton(
                              onPressed: () {
                                managerTools(context, coop);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                              ),
                              child: const Text('Manager Tools'),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                _showModalBottomSheet(context, coop);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                              ),
                              child: Text(
                                coop.members.contains(user?.uid)
                                    ? 'Joined'
                                    : 'Join',
                              ),
                            ),
                          const SizedBox(width: 5),

                          // if member has yet to pay (e.g., paidMembershipFee == false), then show the pay membership button
                          // member.asStream == false ? 
                          isPaid == false ?
                          OutlinedButton(
                            onPressed: () {
                              debugPrint('they have yet to pay: ${memberDetails?.paidMembershipFee}');
                              payMembershipFeeMaya(memberDetails!, ref, context, coop.membershipFee!).then(
                                (value) {
                                  setState(() {
                                    isPaid = !isPaid;
                                  });
                                }
                              );
                              
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10
                              )
                            ),
                            child: Text(
                              'Pay Membership',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary
                              ),
                            )
                          ) : const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                coop.name,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // Joined Date
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Joined December 2023',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${coop.members.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('Members'),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      viewMembers(context, coop);
                    },
                    child: const Text('View Members'),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: TabBar(
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
  }

  // SliverPadding sliverPaddingHeader(
  //     CooperativeModel coop, UserModel? user, BuildContext context) {
  //   return SliverPadding(
  //     padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
  //     sliver: SliverList(
  //       delegate: SliverChildListDelegate(
  //         [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               CircleAvatar(
  //                 backgroundImage: NetworkImage(
  //                   coop.imageUrl!,
  //                 ),
  //                 radius: 35,
  //               ),
  //               coop.managers.contains(user?.uid)
  //                   ? OutlinedButton(
  //                       onPressed: () {
  //                         managerTools(context, coop);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 25,
  //                         ),
  //                       ),
  //                       child: const Text('Manager Tools'),
  //                     )
  //                   : OutlinedButton(
  //                       onPressed: () {
  //                         _showModalBottomSheet(context, coop);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 25,
  //                         ),
  //                       ),
  //                       child: Text(coop.members.contains(user?.uid)
  //                           ? 'Joined'
  //                           : 'Join'),
  //                     ),
  //             ],
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             coop.name,
  //             style: const TextStyle(
  //               fontSize: 19,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 5),
  //           Text(
  //             coop.description ?? '',
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: const TextStyle(
  //               fontSize: 14,
  //             ),
  //           ),
  //           const SizedBox(height: 5),
  //           // Joined Date
  //           Row(
  //             children: [
  //               const Icon(
  //                 Icons.calendar_today,
  //                 size: 14,
  //               ),
  //               const SizedBox(width: 5),
  //               Text(
  //                 'Joined April 2015 !! Constant',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Theme.of(context)
  //                       .colorScheme
  //                       .onSurface
  //                       .withOpacity(0.5),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 5),
  //           Row(
  //             children: [
  //               Text(
  //                 '${coop.members.length}',
  //                 style: const TextStyle(
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(width: 5),
  //               const Text('Members'),
  //               const SizedBox(width: 10),
  //               TextButton(
  //                 onPressed: () {
  //                   viewMembers(context, coop);
  //                 },
  //                 child: const Text('View Members'),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<dynamic> _showModalBottomSheet(
      BuildContext context, CooperativeModel coop) {
    return showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: () => leaveCoop(context, coop),
                  leading: const Icon(Icons.warning),
                  title: const Text('Leave Cooperative'),
                  subtitle: const Text(
                      'Are you sure you want to leave this cooperative?'),
                ),
              ],
            ),
          );
        });
  }

  SliverAppBar sliverAppBar(CooperativeModel coop) {
    return SliverAppBar(
      expandedHeight: MediaQuery.sizeOf(context).height / 5,
      collapsedHeight: kToolbarHeight,
      pinned: true,
      floating: true,
      snap: true,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Calculate the percentage of the expanded height
          double percent = ((constraints.maxHeight - kToolbarHeight) /
              ((MediaQuery.sizeOf(context).height / 10) - kToolbarHeight));
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
            title: percent < 0.8 // Show title when the appBar is 50% collapsed
                ? Row(
                    children: [
                      // CircleAvatar
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          coop.imageUrl!,
                        ),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coop.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${coop.members.length} Members',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : null,
            background: DisplayImage(
              imageUrl: coop.imageUrl,
              height: 150,
              width: double.infinity,
              radius: BorderRadius.zero,
            ),
          );
        },
      ),
      actionsIconTheme: const IconThemeData(
        opacity: 0.5,
      ),
    );
  }
}

class ListVote extends StatelessWidget {
  const ListVote({
    super.key,
    required this.vote,
  });

  final CoopVote vote;

  void readVote(BuildContext context) {
    context.pushNamed(
      'read_vote',
      extra: vote,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        vote.position!,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Due: ${DateFormat.yMMMd().format(vote.dueDate!)}',
      ),
      // Trailing FilledButton Vote
      trailing: FilledButton(
        onPressed: () {
          readVote(context);
          // Vote
        },
        child: const Text('Vote'),
      ),

      onTap: () {
        readVote(context);
        // Navigate to vote details
      },
    );
  }
}
