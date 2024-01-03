import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/common/widgets/leading_back_button.dart';
import 'package:lakbay/models/listing_model.dart';

class CustomerTransportation extends ConsumerStatefulWidget {
  final ListingModel listing;
  const CustomerTransportation({super.key, required this.listing});

  @override
  ConsumerState<CustomerTransportation> createState() =>
      _CustomerTransportationState();
}

class _CustomerTransportationState
    extends ConsumerState<CustomerTransportation> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: LeadingBackButton(ref: ref)
        ),
        body: const SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              
            ]
          )
        )
      )
    );
  }
}
