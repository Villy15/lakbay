import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/error.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/widgets/app_bar.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';

class ReadCoopPage extends ConsumerWidget {
  final String coopId;
  const ReadCoopPage({super.key, required this.coopId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return ref.watch(getCooperativeProvider(coopId)).when(
          data: (data) {
            return Scaffold(
              appBar: CustomAppBar(title: data.name, user: user),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(data.description ?? ''),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Scaffold(
            // appBar: CustomAppBar(title: 'Error', user: user),
            body: ErrorText(error: error.toString()),
          ),
          loading: () => const Scaffold(
            // appBar: CustomAppBar(title: 'Loading...', user: user),
            body: Loader(),
          ),
        );
  }
}
