import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../domain/product.dart';

part 'product_repository.g.dart';

@riverpod
class ProductRepository extends _$ProductRepository {
  late final Box<Product> _box;

  @override
  List<Product> build() {
    _box = Hive.box<Product>('products');

    // Fallback: Populate some dummy data if empty so we can see the UI
    if (_box.isEmpty) {
      final initialProducts = [
        const Product(id: 'p1', title: 'Vanilla Bean', price: 4.50, cost: 2.0, category: ProductCategory.iceCream, imageUrl: ''),
        const Product(id: 'p2', title: 'Strawberry Swirl', price: 4.50, cost: 2.0, category: ProductCategory.iceCream, imageUrl: ''),
        const Product(id: 'p3', title: 'Chocolate Fudge', price: 5.00, cost: 2.2, category: ProductCategory.iceCream, imageUrl: ''),
        const Product(id: 'p4', title: 'Mint Chip', price: 5.00, cost: 2.2, category: ProductCategory.iceCream, imageUrl: ''),
        const Product(id: 'p5', title: 'Cookies & Cream', price: 5.50, cost: 2.5, category: ProductCategory.iceCream, imageUrl: ''),
        const Product(id: 'p6', title: 'Mango Sorbet', price: 4.50, cost: 2.0, category: ProductCategory.iceCream, imageUrl: ''),
        const Product(id: 'p7', title: 'Waffle Cone', price: 1.50, cost: 0.5, category: ProductCategory.vessel, imageUrl: ''),
        const Product(id: 'p8', title: 'Sugar Cone', price: 1.00, cost: 0.3, category: ProductCategory.vessel, imageUrl: ''),
        const Product(id: 'p9', title: 'Cup (Regular)', price: 0.00, cost: 0.1, category: ProductCategory.vessel, imageUrl: ''),
        const Product(id: 'p10', title: 'Sprinkles', price: 0.50, cost: 0.1, category: ProductCategory.topping, imageUrl: ''),
        const Product(id: 'p11', title: 'Hot Fudge', price: 0.75, cost: 0.2, category: ProductCategory.topping, imageUrl: ''),
        const Product(id: 'p12', title: 'Whipped Cream', price: 0.50, cost: 0.1, category: ProductCategory.topping, imageUrl: ''),
        const Product(id: 'p13', title: 'Iced Coffee', price: 3.50, cost: 1.0, category: ProductCategory.drink, imageUrl: ''),
        const Product(id: 'p14', title: 'Milkshake', price: 6.00, cost: 2.5, category: ProductCategory.drink, imageUrl: ''),
        const Product(id: 'p15', title: 'Water Bottle', price: 1.50, cost: 0.3, category: ProductCategory.drink, imageUrl: ''),
      ];
      for (var p in initialProducts) {
        _box.put(p.id, p);
      }
    }
    return _box.values.toList();
  }

  void addProduct(Product product) {
    _box.put(product.id, product);
    state = _box.values.toList();
  }

  void updateProduct(Product product) {
    _box.put(product.id, product);
    state = _box.values.toList();
  }

  void deleteProduct(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }

  void toggleAvailability(String id) {
    final product = _box.get(id);
    if (product != null) {
      final updated = product.copyWith(isAvailable: !product.isAvailable);
      _box.put(id, updated);
      state = _box.values.toList();
    }
  }

  List<Product> getByCategory(ProductCategory category) {
    return _box.values.where((p) => p.category == category).toList();
  }

  List<Product> getAvailable() {
    return _box.values.where((p) => p.isAvailable).toList();
  }
}
