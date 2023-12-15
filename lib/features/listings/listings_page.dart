import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/features/market/widgets/market_card.dart';
import 'package:lakbay/models/coop_model.dart';

class ListingsPage extends ConsumerStatefulWidget {
  final String coopId;
  const ListingsPage({super.key, required this.coopId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListingsPageState();
}

class _ListingsPageState extends ConsumerState<ListingsPage> {
  void addListing(BuildContext context, CooperativeModel coop) {
    context.pushNamed(
      'add_listing',
      extra: coop,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return ref.watch(getCooperativeProvider(widget.coopId)).when(
          data: (CooperativeModel coop) {
            return Scaffold(
              appBar: CustomAppBar(title: 'Listings', user: user),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const MarketCard(),
                    ElevatedButton(
                      onPressed: () {
                        addListing(context, coop);
                      },
                      child: const Text('Add Listing'),
                    ),
                  ],

                  // Add Listing Button
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            // appBar: CustomAppBar(title: 'Error', user: user),
            body: ErrorText(error: error.toString()),
          ),
          loading: () => const Scaffold(
            // appBar: CustomAppBar(title: 'Loading...', user: user),
            body: Loader(),
          ),
        );
  }
}
