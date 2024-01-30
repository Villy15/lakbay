import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/plan/plan_providers.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PlanSelectDate extends ConsumerStatefulWidget {
  const PlanSelectDate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlanSelectDateState();
}

class _PlanSelectDateState extends ConsumerState<PlanSelectDate> {
  // Fields
  DateTime? startDate;
  DateTime? endDate;

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
        appBar: AppBar(
          title: const Text('Select Date'),
        ),
        // Bottom Bar with Cancel or Save
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel
              TextButton(
                onPressed: () {
                  context.pop();
                  ref.read(navBarVisibilityProvider.notifier).show();
                },
                child: const Text('Cancel'),
              ),

              // Save
              FilledButton(
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(120, 45)),
                ),
                onPressed: () {
                  ref
                      .read(planStartDateProvider.notifier)
                      .setStartDate(startDate!);
                  ref.read(planEndDateProvider.notifier).setEndDate(endDate!);
                  context.pop();
                  ref.read(navBarVisibilityProvider.notifier).show();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Calendar
              Expanded(
                  child: SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  startDate = args.value.startDate;
                  endDate = args.value.endDate;
                },
                // Cant select dates before today
                minDate: DateTime.now(),
              )),

              // Button
            ],
          ),
        ),
      ),
    );
  }
}
