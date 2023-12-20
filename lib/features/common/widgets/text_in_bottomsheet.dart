import 'package:flutter/material.dart';
import 'package:lakbay/features/common/widgets/display_text.dart';

String addSpaces(String description) {
  List<String> sentences = description.split('. ');
  for (int i = 3; i < sentences.length; i += 4) {
    sentences[i] = '\n\n\n${sentences[i]}';
  }
  return sentences.join('.');
}

Column TextInBottomSheet(String title, String text, BuildContext context) {
  String descriptionWithSpaces = addSpaces(text);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DisplayText(
          text: descriptionWithSpaces,
          lines: 5,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge?.fontSize,
          ),
        ),
      ),
      if (text.split('\n').length > 5)
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              // show indicator drag
              isScrollControlled: true,
              enableDrag: true,
              showDragHandle: true,
              context: context,
              builder: (context) {
                return Container(
                  height: MediaQuery.sizeOf(context).height * 0.7,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DisplayText(
                          text: title,
                          lines: 1,
                          style: Theme.of(context).textTheme.titleLarge!,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          descriptionWithSpaces,
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.fontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Text('Show More'),
        ),
    ],
  );
}
