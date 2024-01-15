import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/features/sales/sales_repository.dart';
import 'package:lakbay/models/sale_model.dart';

// Stream Provider for get sales
final getSalesProvider = StreamProvider<List<SaleModel>>((ref) {
  final salesController = ref.watch(salesControllerProvider.notifier);
  return salesController.getSales();
});

final salesControllerProvider =
    StateNotifierProvider<SalesController, bool>((ref) {
  final salesRepository = ref.watch(salesRepositoryProvider);
  return SalesController(
    salesRepository: salesRepository,
    ref: ref,
  );
});

class SalesController extends StateNotifier<bool> {
  final SalesRepository _salesRepository;
  // ignore: unused_field
  final Ref _ref;

  SalesController({
    required SalesRepository salesRepository,
    required Ref ref,
  })  : _salesRepository = salesRepository,
        _ref = ref,
        super(false);

  // Read all tasks
  Stream<List<SaleModel>> getSales() {
    return _salesRepository.readSales();
  }
}
