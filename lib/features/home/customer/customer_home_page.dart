import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/search.dart';
import 'package:lakbay/features/home/customer/widgets/customer_home_appbar.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomerHomeAppBar(title: 'Lakbay'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                CustomSearchBar(
                    hintText: 'Where do you want to go?', onTap: () {}),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ));
  }
}
