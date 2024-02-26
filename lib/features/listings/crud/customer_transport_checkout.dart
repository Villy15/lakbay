import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class CustomerTransportCheckout extends ConsumerStatefulWidget {
  final ListingModel listing;
  final AvailableTransport transport;
  final ListingBookings booking;

  const CustomerTransportCheckout(
      {super.key,
      required this.listing,
      required this.transport,
      required this.booking});

  @override
  ConsumerState<CustomerTransportCheckout> createState() =>
      _CustomerTransportCheckoutState();
}

class _CustomerTransportCheckoutState
    extends ConsumerState<CustomerTransportCheckout> {
  late num _guestCount;
  late DateTime _startDate;
  late DateTime _endDate;
  late num _maxGuestCount;
  late ListingBookings updatedBooking;
  final String _paymentOption = 'Full Payment';
  late num vatAmount;
  late num amountTotal;
  late num? days;

  num vat = 1.12;

  @override
  void initState() {
    super.initState();
    _guestCount = widget.booking.guests;
    _maxGuestCount = widget.transport.guests;
    _startDate = widget.booking.startDate!;
    _endDate = widget.booking.endDate!;
    updatedBooking = widget.booking;
    vatAmount = (widget.booking.price * _guestCount) * (vat - 1);
    amountTotal = (widget.booking.price * _guestCount) + vatAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context, "Checkout"),
        body: SingleChildScrollView(
            child: Column(children: [
          _listingSummary(context, widget.listing),
          _tripDetails(context),
          _priceDetails(context),
          _listingRules(context),
          _confirmPay(context)
          //_paymentMethod(context)
        ])));
  }

  AppBar _appBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _listingSummary(BuildContext context, ListingModel listing) {
    List<String?> imageUrls = widget.listing.images!.map((e) => e.url).toList();
    return InkWell(
        onTap: () {},
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: 100,
                  width: 150,
                  child:
                      ImageSlider(images: imageUrls, height: 100, width: 150)),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.listing.title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ])))
            ])));
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
  }

  Widget _tripDetails(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your trip (${widget.listing.type})',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget.booking.typeOfTrip ==
                                      "One Way Trip") ...[
                                    const Text('Date',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(DateFormat.yMMMd().format(_startDate)),
                                    Text(_formatTimeOfDay(
                                        widget.booking.startTime!))
                                  ] else ...[
                                    const Text('Dates',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        '${DateFormat.yMMMd().format(_startDate)} and ${DateFormat.yMMMd().format(_endDate)}'),
                                    Text(
                                        '${_formatTimeOfDay(widget.booking.startTime!)} and ${_formatTimeOfDay(widget.booking.endTime!)}')
                                  ],
                                  Text(
                                    'Number of Guests: $_guestCount',
                                  ),
                                ]),
                            TextButton(
                                onPressed: () async {},
                                child: const Text('Edit'))
                          ])
                    ]))));
  }

  Widget _priceDetails(BuildContext context) {
    bool paymentMoreInfo = false;
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Price details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        // show the only payment option which is full payment
                        ListTile(
                            leading: Icon(Icons.circle,
                                color: Theme.of(context).colorScheme.primary),
                            title: Text(_paymentOption)),
                        Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '₱${widget.booking.price} x $_guestCount guests',
                                    style: const TextStyle(fontSize: 16)),
                                Text(
                                    '₱${(widget.booking.price * _guestCount).toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16))
                              ]),
                          const SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total:',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text('₱${amountTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold))
                              ]),
                          if (paymentMoreInfo == true)
                            Container(
                              child: Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('VAT (12%)',
                                          style: TextStyle(fontSize: 12)),
                                      Text('₱${vatAmount.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 16))
                                    ])
                              ]),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  paymentMoreInfo = true;
                                });
                              },
                              child: const Text('More info'),
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider())
                        ])
                      ]))));
    });
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
              Text('• Leave the vehicle as you found it',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              SizedBox(height: 10),
              Text('• Respect the vehicle and the host’s property',
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmPay(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              const Text(
                  'By confirming below, you agree to our terms and conditions',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    setState(() {
                      // Add your payment action here
                      updatedBooking = updatedBooking.copyWith(
                        paymentOption: _paymentOption,
                        totalPrice: num.parse(amountTotal.toStringAsFixed(2)),
                        amountPaid: num.parse(amountTotal.toStringAsFixed(2)),
                      );
                    });

                    ref
                        .read(listingControllerProvider.notifier)
                        .addBooking(updatedBooking, widget.listing, context);
                    context.pop();
                    // Navigator.pop(context);
                  },
                  child: Text('Confirm and Pay',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 16)))
            ])));
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
                    child: Image.asset('lib/assets/images/paymaya.jpg'),
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
