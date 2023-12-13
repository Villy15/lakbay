import 'package:flutter/material.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/search.dart';
import 'package:lakbay/features/home/customer/widgets/customer_home_appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/market/widgets/market_card.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
        appBar: CustomerHomeAppBar(title: 'Lakbay', user: user),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                CustomSearchBar(
                    hintText: 'Where do you want to go ${user?.name ?? ''}?',
                    onTap: () {}),
                const SizedBox(height: 24.0),
                const MarketCard(),
              ],
            ),
          ),
        ));
  }
}
