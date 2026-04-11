import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/order.dart';

part 'order_repository.g.dart';

@riverpod
class OrderRepository extends _$OrderRepository {
  late final Box<Order> _box;

  @override
  List<Order> build() {
    _box = Hive.box<Order>('orders');
    return _box.values.toList();
  }

  Future<void> saveOrderLocal(Order order) async {
    await _box.put(order.id, order);
    state = _box.values.toList();
  }

  List<Order> getLocalOrders() {
    return _box.values.toList();
  }

  List<Order> getTodaysOrders() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    return _box.values.where((o) {
      return o.timestamp.isAfter(startOfDay);
    }).toList();
  }

  List<Order> getOrdersByDateRange(DateTime start, DateTime end) {
    return _box.values.where((o) {
      return o.timestamp.isAfter(start) && o.timestamp.isBefore(end);
    }).toList();
  }

  List<Order> getOrdersByPaymentMethod(String method) {
    return _box.values.where((o) => o.paymentMethod == method).toList();
  }

  double getTodaysTotalSales() {
    return getTodaysOrders().fold(0.0, (sum, o) => sum + o.totalPrice);
  }

  int getTodaysOrderCount() {
    return getTodaysOrders().length;
  }
}
