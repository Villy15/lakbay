import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';

class Template extends StatelessWidget {
  const Template({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Template'),
      body: SingleChildScrollView (
        child: Column(
          children: [
            Center(
              child: Text('Template Page')
            ),
          ],
        ),
      )
    );
  }
}