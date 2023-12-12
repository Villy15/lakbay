import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    required this.radius,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius!,
      child: Image(
        image: NetworkImage(
          imageUrl!,
        ),
        width: width!,
        height: height!,
        fit: BoxFit.cover,
      ),
    );
  }
}
