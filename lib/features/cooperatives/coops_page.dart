import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';

class CoopsPage extends StatelessWidget {
  const CoopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Coops'),
      body: Center(
        child: Text('CoopsPage Page'),
      ),
    );
  }
}