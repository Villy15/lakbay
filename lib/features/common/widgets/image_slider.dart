// import 'package:carousel_slider/carousel_controller.dart';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final dynamic images;
  final double height;
  final double width;
  const ImageSlider({
    super.key,
    required this.images,
    required this.height,
    required this.width,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int currentImageIndex = 0;
  @override
  Widget build(BuildContext context) {
    int maxImageIndex = widget.images.length;
    CarouselController carouselController = CarouselController();

    return Stack(
      children: [
        InkWell(
          onTap: () {
            showDialog(
                barrierColor: Colors.black.withOpacity(.9),
                context: context,
                builder: (context) {
                  int dialogImageIndex = 0;
                  return StatefulBuilder(builder: (context, setState) {
                    return Dialog(
                      insetPadding: const EdgeInsets.all(0),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: CarouselSlider(
                              carouselController: carouselController,
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: MediaQuery.sizeOf(context).height / 2,
                                enlargeFactor: 0,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    dialogImageIndex = index;
                                  });
                                },
                              ),
                              items: widget.images.map<Widget>((e) {
                                if (e is File) {
                                  return ClipRRect(
                                    // borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      e,
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                } else {
                                  return ClipRRect(
                                    // borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image: NetworkImage(
                                        e,
                                      ),
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }
                              }).toList(),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4),
                                child: Text(
                                  '${dialogImageIndex + 1} / $maxImageIndex',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
                });
          },
          child: SizedBox(
            height: widget.height,
            child: CarouselSlider(
              carouselController: carouselController,
              options: CarouselOptions(
                viewportFraction: 1,
                height: widget.height,
                enlargeFactor: 0,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
              ),
              items: widget.images.map<Widget>((e) {
                if (e is File) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      e,
                      height: widget.height,
                      width: widget.width,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(
                        e,
                      ),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  );
                }
              }).toList(),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Text(
                '${currentImageIndex + 1} / $maxImageIndex',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
