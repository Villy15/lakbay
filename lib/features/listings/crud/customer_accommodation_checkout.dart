import 'dart:async';
import 'dart:convert';

// import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:lakbay/payments/payment_web_view.dart';
import 'package:lakbay/payments/payment_with_paymaya.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uni_links/uni_links.dart';

enum PaymentOption { downpayment, fullPayment }

class CustomerAccommodationCheckout extends ConsumerStatefulWidget {
  final ListingModel listing;
  final AvailableRoom room;
  final ListingBookings booking;

  const CustomerAccommodationCheckout(
      {super.key,
      required this.listing,
      required this.room,
      required this.booking});

  @override
  ConsumerState<CustomerAccommodationCheckout> createState() =>
      _CustomerAccomodationCheckoutState();
}

class _CustomerAccomodationCheckoutState
    extends ConsumerState<CustomerAccommodationCheckout> {
  late num _guestCount;
  late DateTime _startDate;
  late DateTime _endDate;
  late num _nights;
  num vat = 1.12;
  late num _maxGuestCount;
  late ListingBookings updatedBooking;
  late PaymentOption _selectedPaymentOption; // Default value
  late num vatAmount;
  late num downpaymentAmount;
  late num amountDue;

  StreamSubscription? _sub;

  late bool validDownpayment;
  @override
  void initState() {
    super.initState();
    _guestCount = widget.booking.guests;
    _startDate = widget.booking.startDate!;
    _endDate = widget.booking.endDate!;
    _nights = _endDate.difference(_startDate).inDays;
    _maxGuestCount = widget.room.guests;
    updatedBooking = widget.booking;
    downpaymentAmount = widget.listing.downpaymentRate! > 1
        ? widget.listing.downpaymentRate!
        : (widget.booking.price * _nights) * (widget.listing.downpaymentRate!);
    vatAmount = downpaymentAmount * (vat - 1);
    amountDue = vatAmount + downpaymentAmount;

    validDownpayment = _startDate.difference(DateTime.now()).inDays >
            widget.listing.cancellationPeriod! ||
        _startDate.difference(DateTime.now()).inDays >
            widget.listing.downpaymentPeriod!;
    _selectedPaymentOption = validDownpayment == true
        ? PaymentOption.downpayment
        : PaymentOption.fullPayment;

    initUniLinks();
  }

  void initUniLinks() async {
    _sub = getUriLinksStream().listen((Uri? uri) {
      if (uri != null) {
        handleUri(uri);
      }
    }, onError: (err) {
      debugPrint('Failed to get latest link: $err.');
    });
  }

  @override
  void dispose() {
    if (_sub != null) {
      _sub!.cancel();
      _sub = null;
    }
    super.dispose();
  }

  Future<bool> handleUri(Uri uri) async {
    switch (uri.path) {
      case '/payment-success':
        // Assuming some asynchronous operation to validate payment
        // For immediate return, you can just return true;
        return true;

      case '/payment-failure':
        return false;

      case '/payment-cancel':
        return false;

      default:
        // Handle unknown cases
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, "Checkout"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _listingSummary(context, widget.listing),
            _tripDetails(context),
            _priceDetails(context),
            // _paymentMethod(context),
            _listingRules(context),
            _confirmPay(context),
          ],
        ),
      ),
    );
  }

  Widget _confirmPay(BuildContext context) {
    bool paymentSuccessful;
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
            FilledButton(
              // Make it larger
              style: FilledButton.styleFrom(
                // Color
                backgroundColor: Colors.orange.shade700,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Color
              onPressed: () async {
                String paymentOption;
                String paymentStatus;
                num totalPrice = (updatedBooking.price * _nights) * vat * 1;

                if (_selectedPaymentOption.name == "downpayment") {
                  paymentOption = "Downpayment";
                  paymentStatus = "Partially Paid";
                } else {
                  paymentOption = "Full Payment";
                  paymentStatus = "Fully Paid";
                }
                setState(() {
                  updatedBooking = updatedBooking.copyWith(
                      serviceStart: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          widget.listing.checkIn!.hour,
                          widget.listing.checkIn!.minute),
                      paymentOption: paymentOption,
                      paymentStatus: paymentStatus,
                      totalPrice: num.parse(totalPrice.toStringAsFixed(2)),
                      amountPaid: num.parse(amountDue.toStringAsFixed(2)),
                      createdAt: DateTime.now());
                });

                await payWithPaymaya(updatedBooking, widget.listing, ref,
                    context, _selectedPaymentOption.name, amountDue, null);
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

  // Calling the PayMaya API for checkout payment
  // Future<void> payWithPaymaya(ListingBookings listingBookings, WidgetRef ref, BuildContext context) async {
  //   final response = await http.post(
  //     Uri.parse('https://us-central1-lakbay-cd97e.cloudfunctions.net/payWithPaymayaCheckout'),
  //     headers: <String, String> {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic> {
  //       'payment': {
  //         'paymentOption': _selectedPaymentOption.name,
  //         'totalPrice': amountDue,
  //       },
  //       'card': {
  //         'cardNumber': '4123450131001381',
  //         'expMonth': '12',
  //         'expYear': '2025',
  //         'cvv': '123',
  //         'cardType': 'VISA',
  //         'billingAddress': {
  //           'line1': '6F Launchpad',
  //           'line2': 'Reliance Street',
  //           'city': 'Mandaluyong',
  //           'state': 'Metro Manila',
  //           'zipCode': '1552',
  //           'countryCode': 'PH'
  //         }
  //       },
  //       'userDetails': {
  //         'name': listingBookings.customerName,
  //         'phone': listingBookings.customerPhoneNo,
  //       },
  //       'listingDetails': {
  //         'listingId': listingBookings.listingId,
  //         'listingTitle': listingBookings.listingTitle,
  //       },
  //       'redirectUrls' : {
  //         'success': 'https://lakbay.com/payment-success',
  //         'failure': 'https://lakbay.com/payment-failure',
  //         'cancel': 'https://lakbay.com/payment-cancel',
  //       }
  //     }),
  //   );

  //   Map<String, dynamic> responseBody = jsonDecode(response.body);
  //   int statusCode = responseBody['statusCode'];
  //   String redirectUrl = responseBody['redirectUrl'];
  //   Uri uri = Uri.parse(redirectUrl);

  //   if (statusCode == 303) {
  //     debugPrint('Processing checkout. This is the response: $responseBody');
  //     debugPrint('Redirecting to PayMaya checkout page...');

  //     // run launchUrl if want to test the payment since paymentWebView is in-progress
  //     // launchUrl(uri);

  //     // GoRouter.of(context).go('/payment-web-view', arguments: uri);
  //     final bool paymentResult = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PaymentWebView(uri: uri),
  //       ),
  //     );

  //     if (paymentResult) {
  //       debugPrint('The payment was successful!!!');
  //       // Update the booking status to 'Confirmed'
  //       ref
  //           .read(listingControllerProvider.notifier)
  //           // ignore: use_build_context_synchronously
  //           .addBooking(ref, updatedBooking, widget.listing, context);
  //       // show snackbar
  //       // ignore: use_build_context_synchronously
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Payment successful!'),
  //           backgroundColor: Colors.green,
  //         ),
  //       );
  //     }
  //     else {
  //       debugPrint('Payment was unsuccessful. Either cancelled or cannot be processed. Try again later.');
  //       // show snackbar
  //       // ignore: use_build_context_synchronously
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Payment was unsuccessful. Either cancelled or cannot be processed. Try again later.'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }
  //   else {
  //     debugPrint('Failed to process checkout. This is the response: $responseBody');
  //   }
  // }

  Future<void> notifyPublisher(
      ListingModel listingModel, ListingBookings updatedBookings) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-lakbay-cd97e.cloudfunctions.net/notifyPublisherListing'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'notification': {
              'notificationTitle': 'New Booking!',
              'notificationMessage':
                  'Hi, ${listingModel.publisherName}! You have a new booking for your listing: ${listingModel.title}.\n\nCheck your dashboard for more details.',
              'publisherId': listingModel.publisherId,
            },
          }));

      if (response.statusCode == 200) {
        debugPrint(
            'Notification sent successfully. This is the response: ${response.body}');
      } else {
        debugPrint(
            'Failed to send notification. This is the response: ${response.body}');
      }
    } catch (e) {
      debugPrint('This is the error: $e');
    }
  }

  Future<void> notifyPaymentUser(ListingBookings updatedBooking) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-lakbay-cd97e.cloudfunctions.net/notifyUserPaymentListing'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'notification': {
              'notificationTitle': 'Payment Successful!',
              // if the paymentOption is downPayment, then the message will be different
              'notificationMessage': updatedBooking.paymentOption ==
                      'Downpayment'
                  ? 'Hi, ${updatedBooking.customerName}! Your downpayment for ${updatedBooking.listingTitle} has been successfully processed.\n\nPlease settle the remaining balance before your check-in date.'
                  : 'Hi, ${updatedBooking.customerName}! Your payment for ${updatedBooking.listingTitle} has been successfully processed.',
              'userId': updatedBooking.customerId,
            },
          }));

      if (response.statusCode == 200) {
        debugPrint(
            'Notification sent successfully. This is the response: ${response.body}');
      } else {
        debugPrint(
            'Failed to send notification. This is the response: ${response.body}');
      }
    } catch (e) {
      debugPrint('This is the error: $e');
    }
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
    List<String?> imageUrls =
        widget.room.images!.map((roomImage) => roomImage.url).toList();
    return InkWell(
      onTap: () {
        // Handle tap
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Assuming ImageSlider is a custom widget you've defined
            SizedBox(
              height: 100.0, // Define height
              width: 150.0, // and width
              child: ImageSlider(
                  images: imageUrls,
                  height: 100,
                  width: 150,
                  radius: BorderRadius.circular(10)), // Your ImageSlider widget
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.listing.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.room.bedrooms} Bedroom",
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
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
                          child: Container(
                            padding: const EdgeInsets.all(10),
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
                      Text('This place has a maximum of $_maxGuestCount guests',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                              // Italic text
                              fontStyle: FontStyle.italic)),
                    ],
                  ),
                  // Add + and minus button
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

              // Radio buttons for payment options
              if (validDownpayment == true) ...[
                RadioListTile<PaymentOption>(
                  title: const Text('Downpayment'),
                  value: PaymentOption.downpayment,
                  groupValue: _selectedPaymentOption,
                  onChanged: (PaymentOption? value) {
                    setState(() {
                      _selectedPaymentOption = value!;
                      downpaymentAmount = (widget.booking.price * _nights) *
                          widget.listing.downpaymentRate!;
                      vatAmount = (downpaymentAmount) * (vat - 1);
                      amountDue = vatAmount + downpaymentAmount;
                    });
                  },
                ),
                if (_selectedPaymentOption.name == "downpayment")
                  paymentOptionDetails(vatAmount, downpaymentAmount, amountDue),
              ],

              RadioListTile<PaymentOption>(
                title: const Text('Full Payment'),
                value: PaymentOption.fullPayment,
                groupValue: _selectedPaymentOption,
                onChanged: (PaymentOption? value) {
                  setState(() {
                    _selectedPaymentOption = value!;
                    vatAmount = (widget.booking.price * _nights) * (vat - 1);
                    amountDue = (widget.booking.price * _nights) + vatAmount;
                  });
                },
              ),
              if (_selectedPaymentOption.name == "fullPayment")
                paymentOptionDetails(vatAmount, null, amountDue),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentOptionDetails(
      num vatAmount, num? downpaymentAmount, num amountDue) {
    bool paymentMoreInfo = false;
    return StatefulBuilder(builder: (context, setMoreInfo) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('₱${widget.booking.price} x $_nights nights',
                style: const TextStyle(
                  fontSize: 16,
                )),
            Text('₱${(widget.booking.price * _nights).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                )),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('₱${amountDue.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        if (paymentMoreInfo == true)
          // ignore: avoid_unnecessary_containers
          Container(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("VAT (12%): "),
                  Text("₱${vatAmount.toStringAsFixed(2)}"),
                ],
              ),
              if (_selectedPaymentOption == PaymentOption.downpayment)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Downpayment Rate (${(widget.listing.downpaymentRate! * 100).toStringAsFixed(0)}%):"),
                    Text("₱${downpaymentAmount?.toStringAsFixed(2)}"),
                  ],
                ),
            ]),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setMoreInfo(() {
                paymentMoreInfo = true;
              });
            },
            child: const Text('More info'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(),
        ),
      ]);
    });
  }

  // ignore: unused_element
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
                    child: Image.asset('lib/core/images/paymaya.png'),
                  ),
                  Icon(Icons.payment,
                      color: Theme.of(context).colorScheme.primary),
                  // Add more payment method icons as needed
                ],
              ),
              // FilledButton(
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
