import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/models/coop_model.dart';

class JoinCoopCodePage extends ConsumerStatefulWidget {
  final CooperativeModel coop;
  const JoinCoopCodePage({super.key, required this.coop});

  @override
  ConsumerState<JoinCoopCodePage> createState() => _JoinCoopCodePageState();
}

class _JoinCoopCodePageState extends ConsumerState<JoinCoopCodePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(navBarVisibilityProvider.notifier).hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        context.pop();
        ref.read(navBarVisibilityProvider.notifier).show();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Join Cooperative Code')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon to show joining
              const Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.group_add,
                  size: 100,
                ),
              ),

              const SizedBox(height: 20),
              // Join Cooperative Code
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Join Cooperative Code',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Cooperative Code with random number
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Code: ${widget.coop.code}'),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.coop.code ?? '123'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),

              // Join Cooperative Code
            ],
          ),
        ),
      ),
    );
  }
}
