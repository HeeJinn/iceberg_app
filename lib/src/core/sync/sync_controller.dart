import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/orders/domain/order.dart';
import '../../features/orders/data/order_repository.dart';

part 'sync_controller.g.dart';

@riverpod
class SyncController extends _$SyncController {
  @override
  bool build() {
    return false; // isSyncing state
  }

  Future<void> queueOrder(Order order) async {
    final orderRepo = ref.read(orderRepositoryProvider.notifier);
    
    // 1. Immediately save to local offline cache
    await orderRepo.saveOrderLocal(order);
    
    // 2. Trigger async sync process
    _syncToCloud(order);
  }

  Future<void> _syncToCloud(Order order) async {
    state = true; // Syncing
    try {
      // Simulate checking connection and pushing to Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      // On success, we could mark the local order as synced if we extended the model.
    } catch (e) {
      // Sync failed, it remains safely in Hive. The queue re-attempts later.
    } finally {
      state = false;
    }
  }
}
