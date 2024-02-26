// import 'package:cooptourism/core/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lakbay/features/common/widgets/image_slider.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
  PaymentOption _selectedPaymentOption =
      PaymentOption.downpayment; // Default value
  late num vatAmount;
  late num downpaymentAmount;
  late num amountDue;
  @override
  void initState() {
    super.initState();
    _guestCount = widget.booking.guests;
    _startDate = widget.booking.startDate!;
    _endDate = widget.booking.endDate!;
    _nights = _endDate.difference(_startDate).inDays;
    _maxGuestCount = widget.room.guests;
    updatedBooking = widget.booking;
    downpaymentAmount =
        (widget.booking.price * _nights) * widget.listing.downpaymentRate!;
    vatAmount = downpaymentAmount * (vat - 1);
    amountDue = vatAmount + downpaymentAmount;
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
                String paymentOption;
                num totalPrice = (updatedBooking.price * _nights) * vat * 1;

                if (_selectedPaymentOption.name == "downpayment") {
                  paymentOption = "Downpayment";
                } else {
                  paymentOption = "Full Payment";
                }
                setState(() {
                  updatedBooking = updatedBooking.copyWith(
                      paymentOption: paymentOption,
                      totalPrice: num.parse(totalPrice.toStringAsFixed(2)),
                      amountPaid: num.parse(amountDue.toStringAsFixed(2)));
                });
                ref
                    .read(listingControllerProvider.notifier)
                    .addBooking(updatedBooking, widget.listing, context);
                context.pop();
                context.pop();
                context.pop();
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
