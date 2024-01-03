import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class CoopsPage extends ConsumerWidget {
  const CoopsPage({super.key});

  void readCoop(BuildContext context, String id) {
    context.go("/coops/id/$id");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Coops', user: user),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                ref.watch(getAllCooperativesProvider).when(
                      data: (cooperatives) {
                        // return a grid view of cooperatives of 2 rows
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            mainAxisExtent: 260,
                          ),
                          itemCount: cooperatives.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return coopCard(context, cooperatives, index);
                          },
                        );
                      },
                      error: (error, stackTrace) => Scaffold(
                        body: ErrorText(
                          error: error.toString(),
                          stackTrace: stackTrace.toString(),
                        ),
                      ),
                      loading: () => const Loader(),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card coopCard(
      BuildContext context, List<CooperativeModel> cooperatives, int index) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: () {
          readCoop(context, cooperatives[index].uid!);
        },
        splashColor: Colors.orange.withAlpha(30),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  DisplayImage(
                    imageUrl: cooperatives[index].imageUrl,
                    height: 120,
                    width: double.infinity,
                    radius: BorderRadius.circular(20),
                  ),

                  // imageUrl but in circleAvatar
                  Positioned(
                    bottom: 0,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: DisplayImage(
                        imageUrl: cooperatives[index].imageUrl,
                        height: 75,
                        width: 75,
                        radius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Title
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: Text(
                  cooperatives[index].name,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            // Card Description
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                child: Text(
                  cooperatives[index].description ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                ),
              ),
            ),

            // Card Location City
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 4.0, 8.0, 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${cooperatives[index].city}, ${cooperatives[index].province}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Member Count
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.people_alt_outlined,
                          color: Colors.grey,
                        ),
                        Text(
                          '${cooperatives[index].members.length} members',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
