import 'package:flutter/material.dart';

class DisplayText extends StatelessWidget {
  const DisplayText({
    super.key,
    required this.text,
    required this.lines,
    required this.style,
  });

  final String text;
  final int lines;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: lines,
      // textAlign: TextAlign.justify,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: style,
    );
  }
}
