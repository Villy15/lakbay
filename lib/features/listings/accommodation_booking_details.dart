// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class AccommodationBookingsDetails extends ConsumerStatefulWidget {
  final ListingBookings booking;
  final ListingModel listing;
  const AccommodationBookingsDetails({
    super.key,
    required this.booking,
    required this.listing,
  });

  @override
  ConsumerState<AccommodationBookingsDetails> createState() =>
      _AccommodationBookingsDetailsState();
}

class _AccommodationBookingsDetailsState
    extends ConsumerState<AccommodationBookingsDetails> {
  List<SizedBox> tabs = [
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.location_pin),
        child: Text('Tasks'),
      ),
    ),
    const SizedBox(
      width: 100.0,
      child: Tab(
        // icon: Icon(Icons.meeting_room_outlined),
        child: Text('Expenses'),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  AppBar _appBar(String title, BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          // fontFamily: 'Satisfy',
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottom: TabBar(
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.zero,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: tabs,
      ),
    );
  }

  Expanded expenses() {
    List<Expense>? expenses =
        widget.booking.expenses?.toList(growable: true) ?? [];
    return Expanded(
      child: expenses.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: const Center(child: Text("No Expenses Listed")),
            )
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(
                    expense.name,
                    style: const TextStyle(
                      fontSize: 14, // Set your desired font size
                      // Add other styling as needed
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize
                        .min, // Keep the row tight around its children
                    children: [
                      Text(
                        "₱${expense.cost.toString()}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            expenses.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<void> showAddExpenseDialog(
      BuildContext context, ListingBookings booking) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController costController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close the dialog
      builder: (BuildContext context) {
        List<Expense>? expenses = booking.expenses?.toList(growable: true) ??
            []; // Local list to hold expenses
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    // Scrollable list of expenses
                    // Form to add new expense, always visible
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                    TextFormField(
                      controller: costController,
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        labelStyle: TextStyle(fontSize: 14),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          costController.text.isNotEmpty) {
                        booking = booking.copyWith(expenses: expenses);
                        ref
                            .read(listingControllerProvider.notifier)
                            .updateBookingExpenses(
                                context, widget.listing.uid!, booking);
                      } else {
                        context.pop();
                      }
                    }),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    // Add logic to handle the input data
                    String name = nameController.text;
                    num cost = num.parse(costController.text);
                    setState(() {
                      expenses.add(Expense(cost: cost, name: name));

                      debugPrint("$expenses");
                      if (nameController.text.isNotEmpty &&
                          costController.text.isNotEmpty) {
                        booking = booking.copyWith(expenses: expenses);
                        ref
                            .read(listingControllerProvider.notifier)
                            .updateBookingExpenses(
                                context, widget.listing.uid!, booking);
                      }
                    });
                    nameController.clear();
                    costController.clear();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

// ListView tasks() {

//   return ListView.builder(
//                             itemCount: expenses.length,
//                             itemBuilder: (context, index) {
//                               final expense = expenses[index];
//                               return ListTile(
//                                 title: Text(
//                                   expense.name,
//                                   style: const TextStyle(
//                                     fontSize: 14, // Set your desired font size
//                                     // Add other styling as needed
//                                   ),
//                                 ),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize
//                                       .min, // Keep the row tight around its children
//                                   children: [
//                                     Text(
//                                       "₱${expense.cost.toString()}",
//                                       style: const TextStyle(fontSize: 14),
//                                     ),
//                                     IconButton(
//                                       icon: const Icon(Icons.delete),
//                                       onPressed: () {
//                                         setState(() {
//                                           expenses.removeAt(index);
//                                         });
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
// }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate =
        DateFormat('MMMM dd').format(widget.booking.startDate!);
    String formattedEndDate =
        DateFormat('MMMM dd').format(widget.booking.endDate!);
    return PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          context.pop();
          ref.read(navBarVisibilityProvider.notifier).show();
        },
        child: DefaultTabController(
          initialIndex: 0,
          length: tabs.length,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            // Add appbar with back button
            appBar: _appBar("$formattedStartDate - $formattedEndDate", context),
            body: TabBarView(
              children: [
                // tasks(),
                expenses(),
              ],
            ),

            bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.white,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        // Make it wider
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(180, 45)),
                        ),
                        onPressed: () {},
                        child: const Text('Add Task'),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        // Make it wider
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(180, 45)),
                        ),
                        onPressed: () {
                          showAddExpenseDialog(context, widget.booking);
                        },
                        child: const Text('Add Expense'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
