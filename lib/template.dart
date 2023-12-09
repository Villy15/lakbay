import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';

// Stateless Template

class Template extends StatelessWidget {
  const Template({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(title: 'Template'),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text('Template Page')),
            ],
          ),
        ));
  }
}

// ConsumerStateful Template
class ConsumerStateTemplate extends ConsumerStatefulWidget {
  const ConsumerStateTemplate({super.key});

  @override
  ConsumerState<ConsumerStateTemplate> createState() =>
      _ConsumerStateTemplateState();
}

class _ConsumerStateTemplateState extends ConsumerState<ConsumerStateTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Template')),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Text('Template Page')),
            ],
          ),
        ));
  }
}

// Form Template
