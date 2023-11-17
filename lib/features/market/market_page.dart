import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/market/widgets/market_card.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(title: 'Market'),
        body: SingleChildScrollView(
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
