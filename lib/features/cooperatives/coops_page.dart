import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/common/widgets/display_image.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';

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
                          mainAxisExtent: 240,
                        ),
                        itemCount: cooperatives.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            clipBehavior: Clip.hardEdge,
                            elevation: 1,
                            surfaceTintColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: InkWell(
                              onTap: () {
                                readCoop(context, cooperatives[index].uid!);
                              },
                              splashColor: Colors.orange.withAlpha(30),
                              child: Column(
                                children: [
                                  DisplayImage(
                                    imageUrl: cooperatives[index].imageUrl,
                                    height: 125,
                                    width: double.infinity,
                                    radius: BorderRadius.circular(20),
                                  ),

                                  // Card Title
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 8.0, 8.0, 0.0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0.0, 8.0, 0.0),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              4.0, 4.0, 8.0, 8.0),
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
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 4.0, 8.0, 8.0),
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
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorText(error: error.toString()),
                    loading: () => const Loader())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
