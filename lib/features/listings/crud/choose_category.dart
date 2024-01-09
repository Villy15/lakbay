import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/listings/crud/add_accommodation.dart';
import 'package:lakbay/features/listings/listing_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class ChooseCategory extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const ChooseCategory({required this.coop, super.key});

  @override
  ConsumerState<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends ConsumerState<ChooseCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(listingControllerProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose Category'),
        ),
        body: isLoading ?
            const Loader() :
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: chooseCategory(context)
                )

              )
            )
      )
    );
    
  }  
  
  Column chooseCategory(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {'name': 'Accommodation', 'icon': Icons.hotel_outlined},
      {'name': 'Transport', 'icon': Icons.directions_bus_outlined},
      {'name': 'Tour', 'icon': Icons.map_outlined},
      {'name': 'Food', 'icon': Icons.restaurant_outlined},
      {'name': 'Entertainment', 'icon': Icons.movie_creation_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a category appropriate for your listing:',
          style: TextStyle(
            fontSize: 17.0,
            // fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.primary
          ),
        ),
        const SizedBox(height: 16.0),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              onTap: () {
                switch(category['name']) {
                  case 'Accommodation':
                    context.pushNamed('add_accommodation', extra: widget.coop);
                    // context.go('/my_coop/listings/functions/add/accommodation', extra: widget.coop);
                    break;

                  case 'Food':
                    context.pushNamed('add_food', extra: widget.coop);
                    break;
                  
                  case 'Entertainment':
                    context.pushNamed('add_entertainment', extra: widget.coop);
                    break;
                  
                  case 'Transport': 
                    context.pushNamed('add_transport', extra: widget.coop);
                    break;

                  case 'Tour':
                    context.pushNamed('add_tour', extra: widget.coop);
                    break;
                }
              },
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    child: Icon(
                      category['icon'],
                      size: 35.0,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Theme.of(context).colorScheme.primary
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}