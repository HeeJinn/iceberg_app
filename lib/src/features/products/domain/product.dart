import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@HiveType(typeId: 1)
enum ProductCategory {
  @HiveField(0) iceCream,
  @HiveField(1) vessel,
  @HiveField(2) topping,
  @HiveField(3) drink,
  @HiveField(4) other,
}

@freezed
abstract class Product with _$Product {
  // ignore: invalid_annotation_target
  @HiveType(typeId: 2, adapterName: 'ProductAdapter')
  const factory Product({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required double price,
    @HiveField(3) required double cost,
    @HiveField(4) required ProductCategory category,
    @HiveField(5) required String imageUrl,
    @HiveField(6) @Default(true) bool isAvailable,
    @HiveField(7) @Default('') String customCategory,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
