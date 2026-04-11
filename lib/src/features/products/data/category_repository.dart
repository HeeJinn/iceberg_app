import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

part 'category_repository.g.dart';

/// Manages user-defined product categories stored in Hive.
/// Default categories are seeded on first launch.
@riverpod
class CategoryRepository extends _$CategoryRepository {
  late final Box<String> _box;

  static const _defaultCategories = [
    'Ice Cream',
    'Vessel',
    'Topping',
    'Drink',
    'Other',
  ];

  @override
  List<String> build() {
    _box = Hive.box<String>('categories');

    // Seed default categories on first launch
    if (_box.isEmpty) {
      for (int i = 0; i < _defaultCategories.length; i++) {
        _box.put('cat_$i', _defaultCategories[i]);
      }
    }
    return _box.values.toList();
  }

  void addCategory(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    // Prevent duplicates (case-insensitive)
    final existing = _box.values.map((e) => e.toLowerCase()).toSet();
    if (existing.contains(trimmed.toLowerCase())) return;

    final key = 'cat_${DateTime.now().millisecondsSinceEpoch}';
    _box.put(key, trimmed);
    state = _box.values.toList();
  }

  void removeCategory(String name) {
    // Find the key for this category
    final keyToRemove = _box.keys.cast<String>().firstWhere(
          (key) => _box.get(key) == name,
          orElse: () => '',
        );
    if (keyToRemove.isNotEmpty) {
      _box.delete(keyToRemove);
      state = _box.values.toList();
    }
  }

  bool hasCategory(String name) {
    return _box.values.any(
        (v) => v.toLowerCase() == name.trim().toLowerCase());
  }
}
