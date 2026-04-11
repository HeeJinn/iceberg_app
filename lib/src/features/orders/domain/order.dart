import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class OrderItem with _$OrderItem {
  // ignore: invalid_annotation_target
  @HiveType(typeId: 3, adapterName: 'OrderItemAdapter')
  const factory OrderItem({
    @HiveField(0) required String productId,
    @HiveField(1) @Default({}) Map<String, int> modifiers, 
    @HiveField(2) required int quantity,
    @HiveField(3) required double subtotal,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);
}

@freezed
abstract class Order with _$Order {
  // ignore: invalid_annotation_target
  @HiveType(typeId: 4, adapterName: 'OrderAdapter')
  const factory Order({
    @HiveField(0) required String id,
    @HiveField(1) required DateTime timestamp,
    @HiveField(2) required List<OrderItem> items,
    @HiveField(3) required double totalPrice,
    @HiveField(4) required String paymentMethod,
    @HiveField(5) @Default('') String staffId,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
