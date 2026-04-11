import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/order.dart';
import '../data/order_repository.dart';

part 'cart_controller.g.dart';

@riverpod
class CartController extends _$CartController {
  @override
  Order build() {
    return Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      items: [],
      totalPrice: 0.0,
      paymentMethod: '',
      staffId: '',
    );
  }

  void addItem(OrderItem item) {
    final newItems = [...state.items, item];
    state = state.copyWith(
      items: newItems,
      totalPrice: newItems.fold(0, (sum, i) => sum + i.subtotal),
    );
  }

  void removeItem(int index) {
    final newItems = [...state.items];
    if (index >= 0 && index < newItems.length) {
      newItems.removeAt(index);
      state = state.copyWith(
        items: newItems,
        totalPrice: newItems.fold(0, (sum, i) => sum + i.subtotal),
      );
    }
  }

  void updateItemQuantity(int index, int quantity) {
    if (index >= 0 && index < state.items.length && quantity > 0) {
      final item = state.items[index];
      final unitPrice = item.subtotal / item.quantity;
      final updatedItem = item.copyWith(
        quantity: quantity,
        subtotal: unitPrice * quantity,
      );
      final newItems = [...state.items];
      newItems[index] = updatedItem;
      state = state.copyWith(
        items: newItems,
        totalPrice: newItems.fold(0, (sum, i) => sum + i.subtotal),
      );
    }
  }

  void clearCart() {
    state = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      items: [],
      totalPrice: 0.0,
      paymentMethod: '',
      staffId: '',
    );
  }

  Future<Order> checkout(String paymentMethod, String staffId) async {
    final completedOrder = state.copyWith(
      paymentMethod: paymentMethod,
      staffId: staffId,
      timestamp: DateTime.now(),
    );

    // Save to local Hive
    await ref.read(orderRepositoryProvider.notifier).saveOrderLocal(completedOrder);

    final savedOrder = completedOrder;
    clearCart();
    return savedOrder;
  }
}
