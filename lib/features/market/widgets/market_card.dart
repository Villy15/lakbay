import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';

class MarketCard extends ConsumerWidget {
  const MarketCard({super.key});

  void onTap(BuildContext context, WidgetRef ref) {
    ref.read(navBarVisibilityProvider.notifier).hide();
    context
        .push('/market/1')
        .then((_) => {ref.read(navBarVisibilityProvider.notifier).show()});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        surfaceTintColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: InkWell(
          splashColor: Colors.orange.withAlpha(30),
          onTap: () => onTap(context, ref),
          child: SizedBox(
              width: double.infinity,
              height: 325,
              child: Column(
                children: [
                  // Random Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // round the corners of the image
                    child: const Image(
                      image: NetworkImage('https://picsum.photos/250?image=10'),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Card Title
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                      child: Text(
                        'Card Title',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Card Location
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.grey,
                          ),
                          Text(
                            'Card Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Price, Rating, and Distance
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        const Row(
                          children: [
                            Text(
                              '₱1000',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '/night',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star_purple500_outlined,
                              color: Colors.yellow[600],
                            ),
                            const Text(
                              '4.8',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // Distance
                        const Row(
                          children: [
                            Icon(
                              Icons.hotel_outlined,
                            ),
                            SizedBox(width: 4.0),
                            Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
