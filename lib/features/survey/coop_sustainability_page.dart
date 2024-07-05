import 'dart:typed_data';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/events/events_controller.dart';
import 'package:lakbay/features/sales/sales_controller.dart';
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
      'Description': '500 trees planted, 150 volunteers',
      'Value': '500',
      'Color': Colors.brown.shade700,
      'Icon': Icon(Icons.nature, color: Colors.brown.shade700),
    },
    {
      'Category': 'Environmental Sustainability',
      'Metric': 'River and Watershed Protection Programs',
      'Description': '4 events, 1,200 kg waste collected, 200 volunteers',
      'Value': '4 events',
      'Color': Colors.brown.shade700,
      'Icon': Icon(Icons.cleaning_services, color: Colors.brown.shade700),
    },
    // {
    //   'Category': 'Environmental Sustainability',
    //   'Metric': 'Energy and Water Conservation',
    //   'Description': '15% energy reduction, water-saving fixtures installed',
    //   'Value': '15%',
    //   'Color': Colors.brown.shade700,
    //   'Icon': Icon(Icons.water_damage, color: Colors.brown.shade700),
    // },
    {
      'Category': 'Sociocultural Impact',
      'Metric': 'Community Involvement',
      'Description':
          '30% community participation, 3 cultural heritage tours conducted',
      'Value': '30%',
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
    });
  }

  Future<void> savePdfToDevice(Uint8List pdfData, String fileName) async {
    DocumentFileSavePlus().saveMultipleFiles(
      dataList: [pdfData],
      fileNameList: [
        'coop_sustainability_report.pdf',
      ],
      mimeTypeList: [
        'application/pdf',
      ],
    );

    showSnackBar(context, 'PDF saved to device');
  }

  Future<void> viewGeneratedReport() async {
    pdfData = await generateReport(sustainabilityData);
    setState(() {});

    showModalBottomSheet(
      // ignore: use_build_context_synchronously
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
                    await savePdfToDevice(
                        pdfData!, 'coop_sustainability_report.pdf');
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
    final user = ref.watch(userProvider);

    final events =
        ref.watch(getEventsByCoopIdProvider(user!.currentCoop!)).asData?.value;

    final sales =
        ref.watch(getSalesByCoopIdProvider(user.currentCoop!)).asData?.value;

    num treesPlantedEvents = 0;
    num treesPlanted = 0;
    num treesPlantedParticipants = 0;

    num wasteCollectedEvents = 0;
    num wasteCollected = 0;
    num wasteCollectedParticipants = 0;

    num workshopEvents = 0;
    num workshopParticipants = 0;

    num totalSales = sales?.length ?? 0;
    num salesRevenue = 0;
    num servicesBooked = 0;
    num accommodationPercentage = 0;
    num transportPercentage = 0;
    num foodPercentage = 0;
    num tourPercentage = 0;
    num entertainmentPercentage = 0;

    num totalMembers = 0;
    num totalCoopMembers = 0;
    num totalCommunityMembers = 0;

    if (events == null) {
      return const Center(child: CircularProgressIndicator());
    }

    for (var event in events) {
      // loook for the event with name "Tree Planting"
      if (event.name == 'River and Watershed Protection Programs') {
        wasteCollectedEvents++;
        wasteCollected += event.goalsAndObjectives?.first.objective ?? 0;
        wasteCollectedParticipants += event.members.length;
      }

      if (event.name == 'Tree Planting') {
        treesPlantedEvents++;
        treesPlanted += event.goalsAndObjectives?.first.objective ?? 0;
        treesPlantedParticipants += event.members.length;
      }

      if (event.eventType == 'Training and Education') {
        workshopEvents++;
        workshopParticipants += event.members.length;
      }

      // Check if the uid of a participant of an event is under the coop
      for (var member in event.members) {
        totalMembers++;
        ref.read(getUserDataProvider(member)).whenData((memberData) {
          bool isMemberInCoop = memberData.cooperativesJoined
                  ?.any((coop) => coop.cooperativeId == user.currentCoop) ??
              false;

          if (!isMemberInCoop) {
            totalCommunityMembers++;
          } else {
            totalCoopMembers++;
          }
        });
      }
    }

    totalCommunityMembers = (totalCommunityMembers / totalMembers) * 100;
    totalCoopMembers = (totalCoopMembers / totalMembers) * 100;

    if (sales == null) {
      return const Center(child: CircularProgressIndicator());
    }

    for (var sale in sales) {
      salesRevenue += sale.saleAmount;
      servicesBooked += 1;

      if (sale.category == 'Accommodation') {
        accommodationPercentage += 1;
      } else if (sale.category == 'Transport') {
        transportPercentage += 1;
      } else if (sale.category == 'Food') {
        foodPercentage += 1;
      } else if (sale.category == 'Tour') {
        tourPercentage += 1;
      } else if (sale.category == 'Entertainment') {
        entertainmentPercentage += 1;
      }
    }

    // Convert counts to percentages
    accommodationPercentage = (accommodationPercentage / totalSales) * 100;
    transportPercentage = (transportPercentage / totalSales) * 100;
    foodPercentage = (foodPercentage / totalSales) * 100;
    tourPercentage = (tourPercentage / totalSales) * 100;
    entertainmentPercentage = (entertainmentPercentage / totalSales) * 100;

    void updateSustainabilityData() {
      // Find the index of the tree planting data in the sustainabilityData list
      int treePlantingIndex = sustainabilityData
          .indexWhere((data) => data['Metric'] == 'Tree Planting Events');
      if (treePlantingIndex != -1) {
        // Update the tree planting data
        sustainabilityData[treePlantingIndex]['Description'] =
            '$treesPlantedEvents events ${treesPlanted.round()} trees planted, $treesPlantedParticipants volunteers';
        sustainabilityData[treePlantingIndex]['Value'] =
            '${treesPlanted.round()} trees planted';
      }

      // Similarly, update other metrics if needed

      // Find the index of the waste collection data in the sustainabilityData list
      int wasteCollectionIndex = sustainabilityData.indexWhere((data) =>
          data['Metric'] == 'River and Watershed Protection Programs');

      if (wasteCollectionIndex != -1) {
        // Update the waste collection data
        sustainabilityData[wasteCollectionIndex]['Description'] =
            '$wasteCollectedEvents events $wasteCollected kg waste collected, $wasteCollectedParticipants volunteers';
        sustainabilityData[wasteCollectionIndex]['Value'] =
            '$wasteCollected kg waste collected';
      }

      int workshopIndex = sustainabilityData.indexWhere(
          (data) => data['Metric'] == 'Educational and Skill Development');

      if (workshopIndex != -1) {
        // Update the waste collection data
        sustainabilityData[workshopIndex]['Description'] =
            '$workshopEvents events, $workshopParticipants beneficiaries';
        sustainabilityData[workshopIndex]['Value'] = '$workshopEvents events';
      }

      int salesIndex = sustainabilityData
          .indexWhere((data) => data['Metric'] == 'Sales and Revenue');

      if (salesIndex != -1) {
        // Update the waste collection data
        sustainabilityData[salesIndex]['Description'] =
            'Total Revenue: PHP ${salesRevenue.toStringAsFixed(2)}';
        sustainabilityData[salesIndex]['Value'] =
            'PHP ${salesRevenue.toStringAsFixed(2)}';
      }

      int serviceIndex = sustainabilityData
          .indexWhere((data) => data['Metric'] == 'Service Performance');

      if (serviceIndex != -1) {
        // Update the waste collection data
        sustainabilityData[serviceIndex]['Description'] =
            '$servicesBooked services booked Accommodation: ${accommodationPercentage.toStringAsFixed(0)}% Transport: ${transportPercentage.toStringAsFixed(0)}% Food: ${foodPercentage.toStringAsFixed(0)}% Tour: ${tourPercentage.toStringAsFixed(0)}% Entertainment: ${entertainmentPercentage.toStringAsFixed(0)}%';
        sustainabilityData[serviceIndex]['Value'] =
            '$servicesBooked services booked';
      }

      int communityIndex = sustainabilityData
          .indexWhere((data) => data['Metric'] == 'Community Involvement');

      if (communityIndex != -1) {
        // Update the waste collection data
        sustainabilityData[communityIndex]['Description'] =
            '${totalCommunityMembers.round()}% community participation, ${totalCoopMembers.round()}% cooperative members';
        sustainabilityData[communityIndex]['Value'] =
            '${totalCommunityMembers.round()}% community involvement';
      }
    }

    updateSustainabilityData();

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        ref.read(navBarVisibilityProvider.notifier).show();
        context.pop();
      },
      child: Scaffold(
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
                          buildMetricCard(
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
      ),
    );
  }

  Widget buildMetricCard(BuildContext context, String title, String description,
      String value, Color color, Icon icon) {
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
