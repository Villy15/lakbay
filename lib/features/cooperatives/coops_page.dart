import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';

class CoopsPage extends ConsumerWidget {
  const CoopsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: CustomAppBar(title: 'Coops', user: user),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              ref.watch(getAllCooperativesProvider).when(
                  data: (cooperatives) => ListView.builder(
                        shrinkWrap: true,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          final cooperative = cooperatives[index];
                          return ListTile(
                            title: Text(cooperative.name),
                            subtitle: Text(cooperative.description ?? ''),
                            onTap: () =>
                                context.go('/coops/id/${cooperative.uid}'),
                          );
                        },
                      ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader())
            ],
          ),
        ),
      ),
    );
  }
}
