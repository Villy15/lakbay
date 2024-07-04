/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateReport(
    List<Map<String, dynamic>> sustainabilityData) async {
  const baseColor = PdfColors.orange;
  final document = pw.Document();
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(
        await rootBundle.load("lib/core/fonts/OpenSans-Regular.ttf")),
    bold:
        pw.Font.ttf(await rootBundle.load("lib/core/fonts/OpenSans-Bold.ttf")),
  );

  // Extract unique categories
  final categories = sustainabilityData.map((e) => e['Category']).toSet();

  // Iterate over each category to create a new page
  for (var category in categories) {
    final metrics = sustainabilityData
        .where((data) => data['Category'] == category)
        .toList();

    document.addPage(
      pw.Page(
        theme: theme,
        build: (context) {
          return pw.Column(
            children: [
              pw.Text('Sustainability Report - $category',
                  style: const pw.TextStyle(color: baseColor, fontSize: 40)),
              pw.SizedBox(height: 20),
              ...metrics.map((data) {
                return _buildMetricCard(
                  title: data['Metric'],
                  description: data['Description'],
                  value: data['Value'],
                );
              }),
              pw.SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  return document.save();
}

pw.Widget _buildMetricCard({
  required String title,
  required String description,
  required String value,
}) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 8),
    padding: const pw.EdgeInsets.all(16),
    child: pw.Row(
      children: [
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
              pw.Text(
                description,
                style: const pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.black,
                ),
              ),
              if (value.isNotEmpty)
                pw.Text(
                  value,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
