import 'package:flutter/material.dart';

class TimelineTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final bool isLast;
  final bool isActive;

  const TimelineTile({
    super.key,
    required this.leading,
    required this.title,
    this.isLast = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            const SizedBox(
                width: 8), // Spacing between the leading and the line

            Column(
              children: [
                // Timeline indicator circle
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
                // Vertical line for the timeline
                Expanded(
                  child: Container(
                    width: 2,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.2),
                  ),
                ),
                // Add extra spacing if it is the last element
                if (isLast)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(
                width: 8), // Spacing between the line and the content
            // The child content of the timeline tile
            Expanded(child: title),
          ],
        ),
      ),
    );
  }
}
