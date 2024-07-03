import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  List<Map<String, dynamic>> sustainabilityData = [
    {
      'Category': 'Environmental Sustainability',
      'Metric': 'Tree Planting Events',
      'Description': '500 trees planted, 2 hectares covered, 150 volunteers',
      'Value': '500',
      'Color': Colors.brown.shade700,
      'Icon': Icon(Icons.nature, color: Colors.brown.shade700),
    },
    {
      'Category': 'Environmental Sustainability',
      'Metric': 'River Clean-Up Activities',
      'Description': '4 events, 1,200 kg waste collected, 200 volunteers',
      'Value': '4 events',
      'Color': Colors.brown.shade700,
      'Icon': Icon(Icons.cleaning_services, color: Colors.brown.shade700),
    },
    {
      'Category': 'Environmental Sustainability',
      'Metric': 'Energy and Water Conservation',
      'Description': '15% energy reduction, water-saving fixtures installed',
      'Value': '15%',
      'Color': Colors.brown.shade700,
      'Icon': Icon(Icons.water_damage, color: Colors.brown.shade700),
    },
    {
      'Category': 'Sociocultural Impact',
      'Metric': 'Community Involvement',
      'Description': '80% local employment, 3 cultural heritage tours',
      'Value': '80%',
      'Color': Colors.orange.shade900,
      'Icon': Icon(Icons.people, color: Colors.orange.shade900),
    },
    {
      'Category': 'Sociocultural Impact',
      'Metric': 'Educational and Skill Development',
      'Description': '5 workshops, 100 beneficiaries',
      'Value': '5',
      'Color': Colors.orange.shade900,
      'Icon': Icon(Icons.school, color: Colors.orange.shade900),
    },
    {
      'Category': 'Economic Performance',
      'Metric': 'Sales and Revenue',
      'Description': 'Total Revenue: PHP 5,000,000, 10% revenue growth',
      'Value': 'PHP 5,000,000',
      'Color': Colors.green.shade900,
      'Icon': Icon(Icons.attach_money, color: Colors.green.shade900),
    },
    {
      'Category': 'Economic Performance',
      'Metric': 'Service Performance',
      'Description':
          '75% accommodation occupancy, 85% tour participation, 90% customer satisfaction',
      'Value': '75%',
      'Color': Colors.green.shade900,
      'Icon': Icon(Icons.star_rate, color: Colors.green.shade900),
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(navBarVisibilityProvider.notifier).hide();
      pdfData = await generateReport(sustainabilityData);
      setState(() {});
    });
  }

  void viewGeneratedReport() {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Generated Report'),
          ),
          // Save the generated report to the device
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    // Add logic here to save the PDF to the device if needed
                    // Example: await savePDFToDevice(pdfData);
                  },
                  child: const Text('Save PDF'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
          body: pdfData != null
              ? PDFView(
                  pdfData: pdfData!,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewGeneratedReport();
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
      appBar: AppBar(
        title: const Text('Coop Sustainability Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var category in sustainabilityData
                  .map((data) => data['Category'] as String)
                  .toSet())
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (var data in sustainabilityData)
                      if (data['Category'] == category)
                        _buildMetricCard(
                          context,
                          data['Metric']!,
                          data['Description']!,
                          data['Value']!,
                          data['Color']!,
                          data['Icon']!,
                        ),
                    const SizedBox(height: 10),
                  ],
                ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title,
      String description, String value, Color color, Icon icon) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon.icon, size: 40, color: Colors.white),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  if (value.isNotEmpty)
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
