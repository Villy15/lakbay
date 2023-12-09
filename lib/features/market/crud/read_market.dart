import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';

class ReadMarketPage extends ConsumerStatefulWidget {
  const ReadMarketPage({super.key});

  @override
  ConsumerState<ReadMarketPage> createState() => _ReadMarketPageState();
}

class _ReadMarketPageState extends ConsumerState<ReadMarketPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  void pop() {
    context.pop();
    ref.read(navBarVisibilityProvider.notifier).show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          pop();
        },
        child: Scaffold(
          // Add appbar with back button
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              iconSize: 20,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1.0,
                    height: 250.0,
                    enlargeFactor: 0,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {},
                  ),
                  items: const [
                    Image(
                      image: NetworkImage('https://picsum.photos/250?image=10'),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Image(
                      image: NetworkImage('https://picsum.photos/250?image=10'),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Image(
                      image: NetworkImage('https://picsum.photos/250?image=10'),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              ],
            ),
          ),
          // Bottom Nav Bar with price on the left and Book Now on the right
          bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.white,
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              Text('₱12000.00',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text('/night',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    // Make it wider
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(180, 45)),
                    ),
                    onPressed: () {},
                    child: const Text('Book Now'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
