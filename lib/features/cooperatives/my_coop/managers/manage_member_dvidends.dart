import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/loader.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/cooperatives/coops_controller.dart';
import 'package:lakbay/models/coop_model.dart';

class ManageMemberDividends extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  final CooperativeModel coop;
  const ManageMemberDividends(
      {super.key, required this.parentContext, required this.coop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManageMemberDividendsState();
}

class _ManageMemberDividendsState extends ConsumerState<ManageMemberDividends> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _feeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSubmit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final coop = widget.coop.copyWith(
        membershipDividends: double.parse(_feeController.text),
      );

      ref.read(coopsControllerProvider.notifier).editCooperative(coop, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coopsControllerProvider);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.95,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Member Dividends'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(navBarVisibilityProvider.notifier).show();
              context.pop(widget.parentContext);
            },
          ),
        ),
        bottomNavigationBar: _bottomNavBar(context),
        body: isLoading ? const Loader() : _body(),
      ),
    );
  }

  BottomAppBar _bottomNavBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(120, 45)),
            ),
            onPressed: () {
              onSubmit();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  icon: Icon(Icons.monetization_on),
                  border: OutlineInputBorder(),
                  prefix: Text('₱'),
                  labelText: 'Member Dividends*',
                  helperText: '*required',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
