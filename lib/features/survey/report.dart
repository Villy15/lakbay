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

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateReport(
    List<Map<String, dynamic>> sustainabilityData) async {
  const baseColor = PdfColors.orange;
  final document = pw.Document();

  // Extract unique categories
  final categories = sustainabilityData.map((e) => e['Category']).toSet();

  final pageTheme = await _myPageTheme();

  final tree = await rootBundle.loadString('lib/core/images/tree.svg');
  final money = await rootBundle.loadString('lib/core/images/money.svg');
  final river = await rootBundle.loadString('lib/core/images/river.svg');
  final people = await rootBundle.loadString('lib/core/images/people.svg');

  // Iterate over each category to create a new page
  for (var category in categories) {
    final metrics = sustainabilityData
        .where((data) => data['Category'] == category)
        .toList();

    document.addPage(
      pw.Page(
        pageTheme: pageTheme,
        build: (context) {
          return pw.Column(
            children: [
              pw.Text(
                'Sustainability Report - $category',
                style: pw.TextStyle(
                  color: baseColor,
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              ...metrics.map((data) {
                return _buildMetricCard(
                  title: data['Metric'],
                  description: data['Description'],
                  value: data['Value'],
                  tree: tree,
                  people: people,
                  river: river,
                  money: money,
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

Future<pw.PageTheme> _myPageTheme() async {
  final bgShape = await rootBundle.loadString('lib/core/images/Resume.svg');

  return pw.PageTheme(
    theme: pw.ThemeData.withFont(
      base: pw.Font.ttf(
          await rootBundle.load("lib/core/fonts/OpenSans-Regular.ttf")),
      bold: pw.Font.ttf(
          await rootBundle.load("lib/core/fonts/OpenSans-Bold.ttf")),
    ),
    buildBackground: (pw.Context context) {
      return pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Positioned(
              child: pw.SvgImage(svg: bgShape),
              left: 0,
              top: 0,
            ),
            pw.Positioned(
              child: pw.Transform.rotate(
                  angle: pi, child: pw.SvgImage(svg: bgShape)),
              right: 0,
              bottom: 0,
            ),
          ],
        ),
      );
    },
  );
}

pw.Widget _buildMetricCard({
  required String title,
  required String description,
  required String value,
  required String tree,
  required String people,
  required String river,
  required String money,
}) {
  return pw.Container(
    margin: const pw.EdgeInsets.symmetric(vertical: 8),
    padding: const pw.EdgeInsets.all(16),
    child: pw.Row(
      children: [
        if (title == 'Tree Planting Events') ...[
          pw.SvgImage(svg: tree, width: 40, height: 40),
        ] else if (title == 'Community Involvement') ...[
          pw.SvgImage(svg: people, width: 40, height: 40),
        ] else if (title == 'River and Watershed Protection Programs') ...[
          pw.SvgImage(svg: river, width: 40, height: 40),
        ] else if (title == 'Sales and Revenue') ...[
          pw.SvgImage(svg: money, width: 40, height: 40),
        ] else
          pw.SvgImage(svg: people, width: 40, height: 40),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
              pw.Text(
                description,
                style: const pw.TextStyle(
                  fontSize: 20,
                  color: PdfColors.black,
                ),
              ),
              if (value.isNotEmpty)
                pw.Text(
                  value,
                  style: pw.TextStyle(
                    fontSize: 40,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              pw.Divider(),
            ],
          ),
        ),
      ],
    ),
  );
}
