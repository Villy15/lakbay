// import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookAccommodation extends StatefulWidget {
  final ListingModel listing;

  const BookAccommodation({super.key, required this.listing});

  @override
  State<BookAccommodation> createState() => _BookAccommodationState();
}

class _BookAccommodationState extends State<BookAccommodation> {
  int _guestCount = 1;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 5));
  int _nights = 5;
  int maxGuestCount = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Confirm and Pay"),
      body: ListView(
        children: [
          _listingSummary(context, widget.listing),
          _tripDetails(context),
          _priceDetails(context),
          _paymentMethod(context),
          _listingRules(context),
          _confirmPay(context),
        ],
      ),
    );
  }

  Widget _confirmPay(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'By confirming below, you agree to our terms and conditions, and privacy policy.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Add some spacing
            ElevatedButton(
              // Make it larger
              style: ElevatedButton.styleFrom(
                // Color
                backgroundColor: Colors.orange.shade700,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Color
              onPressed: () {
                // Add your confirm and pay action here
              },
              child: Text('Confirm and Pay',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listingRules(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ground Rules',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(
                  'We ask the guest to remember a few simple about what makes a great guest: ',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              // Add a bulleted point list of text
              SizedBox(height: 10),
              Text('• Communicate with your host',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              SizedBox(height: 10),
              Text('• Leave the place as you found it',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              SizedBox(height: 10),
              Text('• Treat your host\'s home like your own home',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _listingSummary(BuildContext context, ListingModel listing) {
    // You will need to replace the Image.network with an image from your model
    return ListTile(
      leading: DisplayImage(
        imageUrl:
            "cooperatives/${widget.listing.cooperative.cooperativeName}/${widget.listing.images![0]}",
        height: 100,
        width: 100,
        radius: const BorderRadius.only(),
      ),
      title: Text(
        widget.listing.title,
        style: const TextStyle(
            fontSize: 20,
            // color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
          Text('${listing.rating?.toStringAsFixed(2)} (5 reviews)'),
        ],
      ),
    );
  }

  Widget _tripDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your trip',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dates',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                          '${DateFormat('dd MMM').format(_startDate)} - ${DateFormat('dd MMM').format(_endDate)} (${_endDate.difference(_startDate).inDays} nights)',
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await showDialog<PickerDateRange>(
                        context: context,
                        builder: (context) => Dialog(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.8, // 80% of screen width
                            height: MediaQuery.of(context).size.height *
                                0.6, // 60% of screen height
                            child: SfDateRangePicker(
                              // onSelectionChanged: _onDateSelection,
                              selectionMode: DateRangePickerSelectionMode.range,
                              initialSelectedRange: PickerDateRange(
                                _startDate,
                                _endDate,
                              ),
                              showActionButtons:
                                  true, // Enable the confirm and cancel buttons
                              onSubmit: (value) {
                                Navigator.pop(context, value);
                              },
                              onCancel: () {
                                Navigator.pop(context, null);
                              },
                            ),
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _startDate = result.startDate!;
                          _endDate = result.endDate!;
                          _nights = _endDate.difference(_startDate).inDays;
                        });
                      }
                    },
                    child: const Text('Edit',
                        style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Guests',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${_guestCount.toString()} Guests',
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                      Text('This place has a maximum of $maxGuestCount guests',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              // Italic text
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                  // Add + and minus button
                  Row(
                    children: [
                      if (_guestCount > 1)
                        IconButton(
                          onPressed: _decrementGuestCount,
                          icon: Icon(Icons.remove_circle_outline,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      Text(_guestCount.toString()),
                      IconButton(
                        onPressed: _guestCount >= maxGuestCount
                            ? null
                            : _incrementGuestCount,
                        icon: Icon(Icons.add_circle_outline,
                            color: _guestCount >= maxGuestCount
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _incrementGuestCount() {
    setState(() {
      _guestCount++;
    });
  }

  void _decrementGuestCount() {
    setState(() {
      _guestCount--;
    });
  }

  Widget _priceDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₱${widget.listing.price} x $_nights nights',
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                  // Text(
                  //     '₱${(widget.listing.price * _nights).toStringAsFixed(2)}',
                  //     style: const TextStyle(
                  //       fontSize: 16,
                  //     )),
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Divider(),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  // Text(
                  //     '₱${(widget.listing.price * _nights * 1.12).toStringAsFixed(2)}',
                  //     style: const TextStyle(
                  //         fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add your more info action here
                  },
                  child: const Text('More info'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentMethod(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pay with',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 70, // specify the width
                    height: 40, // specify the height
                    child: Image.asset("lib/core/images/paymaya.png"),
                  ),
                  Icon(Icons.payment,
                      color: Theme.of(context).colorScheme.primary),
                  // Add more payment method icons as needed
                ],
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     // Add your payment action here
              //   },
              //   child: const Text('Add Payment Method'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
