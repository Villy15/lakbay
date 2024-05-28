import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/survey/report.dart';

class CoopSustainabilityPage extends ConsumerStatefulWidget {
  const CoopSustainabilityPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoopSustainabilityPageState();
}

class _CoopSustainabilityPageState
    extends ConsumerState<CoopSustainabilityPage> {
  Uint8List? pdfData;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(navBarVisibilityProvider.notifier).hide();
      pdfData = await generateReport();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Coop Sustainability'),
        ),
        body: pdfData != null
            ? PDFView(
                pdfData: pdfData,
              )
            : const Center(
                child:
                    CircularProgressIndicator()), // Show a loading spinner while the PDF is loading
      ),
    );
  }
}
