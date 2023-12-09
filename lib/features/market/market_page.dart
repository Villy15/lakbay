import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/market/widgets/market_card.dart';

class MarketPage extends ConsumerWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
        appBar: CustomAppBar(title: 'Market', user: user),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                MarketCard(),
              ],
            ),
          ),
        ));
  }
}
