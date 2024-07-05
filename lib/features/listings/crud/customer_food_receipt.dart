import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/models/listing_model.dart';
import 'package:lakbay/models/subcollections/listings_bookings_model.dart';

class CustomerFoodReceipt extends ConsumerWidget {
  final ListingModel listing;
  final ListingBookings booking;

  const CustomerFoodReceipt(
      {super.key, required this.listing, required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Booking Receipt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 80),
                    const SizedBox(height: 10),
                    const Text(
                      "Booking Successful!",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Booking Reference: ${booking.id}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const Divider(thickness: 2),
              const Text(
                "Payment Details",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 10),
              _buildReceiptTile(
                icon: Icons.fastfood,
                label: "Food Price",
                value: '₱${booking.price.toStringAsFixed(2)}',
              ),
              _buildReceiptTile(
                icon: Icons.money,
                label: "Amount Paid",
                value: '₱${booking.amountPaid!.toStringAsFixed(2)}',
              ),
              _buildReceiptTile(
                icon: Icons.money_off,
                label: "Amount Due",
                value:
                    '₱${(booking.totalPrice! - booking.amountPaid!).toStringAsFixed(2)}',
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 2),
              const Text(
                "Booking Information",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 10),
              _buildReceiptTile(
                icon: Icons.payment,
                label: "Payment Option",
                value: booking.paymentOption ?? "-",
              ),
              _buildReceiptTile(
                icon: Icons.check_circle,
                label: "Status",
                value: booking.bookingStatus,
              ),
              _buildReceiptTile(
                icon: Icons.title,
                label: "Listing Title",
                value: listing.title,
              ),
              _buildReceiptTile(
                icon: Icons.group,
                label: "Guests",
                value: booking.guests.toString(),
              ),
              _buildReceiptTile(
                icon: Icons.person,
                label: "Customer Name",
                value: booking.customerName,
              ),
              _buildReceiptTile(
                icon: Icons.phone,
                label: "Customer No.",
                value: booking.customerPhoneNo,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text("Close")),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange.shade900),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
