import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

part 'modifier_options_repository.g.dart';

/// A single modifier option (vessel or flavor) with a name and price.
class ModifierOption {
  final String name;
  final double price;

  const ModifierOption({required this.name, this.price = 0.0});

  Map<String, dynamic> toJson() => {'name': name, 'price': price};

  factory ModifierOption.fromJson(Map<String, dynamic> json) {
    return ModifierOption(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  String encode() => jsonEncode(toJson());

  static ModifierOption decode(String raw) {
    return ModifierOption.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Returns a display label like "Cup" or "Waffle Cone (+₱0.50)"
  String get displayLabel {
    if (price > 0) {
      return '$name (+\u20B1${price.toStringAsFixed(2)})';
    }
    return name;
  }

  ModifierOption copyWith({String? name, double? price}) {
    return ModifierOption(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}

// ---------------------------------------------------------------------------
// Vessel Options
// ---------------------------------------------------------------------------

@riverpod
class VesselOptionsRepository extends _$VesselOptionsRepository {
  late final Box<String> _box;

  static const _defaults = [
    ModifierOption(name: 'Cup', price: 0.0),
    ModifierOption(name: 'Sugar Cone', price: 0.0),
    ModifierOption(name: 'Waffle Cone', price: 0.50),
  ];

  @override
  List<ModifierOption> build() {
    _box = Hive.box<String>('vessel_options');

    // Only seed defaults on very first launch (sentinel key absent).
    // Once initialized, the user can clear everything and it stays empty.
    if (!_box.containsKey('_initialized')) {
      for (int i = 0; i < _defaults.length; i++) {
        _box.put('v_$i', _defaults[i].encode());
      }
      _box.put('_initialized', 'true');
    }
    return _box.values
        .where((v) => v != 'true') // skip sentinel
        .map(ModifierOption.decode)
        .toList();
  }

  List<ModifierOption> _readAll() {
    return _box.values
        .where((v) => v != 'true')
        .map(ModifierOption.decode)
        .toList();
  }

  void add(ModifierOption option) {
    final key = 'v_${DateTime.now().millisecondsSinceEpoch}';
    _box.put(key, option.encode());
    state = _readAll();
  }

  void remove(String name) {
    final keyToRemove = _box.keys.cast<String>().firstWhere(
          (key) {
            if (key == '_initialized') return false;
            final opt = ModifierOption.decode(_box.get(key)!);
            return opt.name == name;
          },
          orElse: () => '',
        );
    if (keyToRemove.isNotEmpty) {
      _box.delete(keyToRemove);
      state = _readAll();
    }
  }

  void update(String oldName, ModifierOption updated) {
    final keyToUpdate = _box.keys.cast<String>().firstWhere(
          (key) {
            if (key == '_initialized') return false;
            final opt = ModifierOption.decode(_box.get(key)!);
            return opt.name == oldName;
          },
          orElse: () => '',
        );
    if (keyToUpdate.isNotEmpty) {
      _box.put(keyToUpdate, updated.encode());
      state = _readAll();
    }
  }
}

// ---------------------------------------------------------------------------
// Flavor Options
// ---------------------------------------------------------------------------

@riverpod
class FlavorOptionsRepository extends _$FlavorOptionsRepository {
  late final Box<String> _box;

  static const _defaults = [
    ModifierOption(name: 'Vanilla', price: 0.0),
    ModifierOption(name: 'Chocolate', price: 0.0),
    ModifierOption(name: 'Strawberry', price: 0.0),
    ModifierOption(name: 'Mint Chip', price: 0.0),
    ModifierOption(name: 'Cookies & Cream', price: 0.0),
  ];

  @override
  List<ModifierOption> build() {
    _box = Hive.box<String>('flavor_options');

    // Only seed defaults on very first launch (sentinel key absent).
    if (!_box.containsKey('_initialized')) {
      for (int i = 0; i < _defaults.length; i++) {
        _box.put('f_$i', _defaults[i].encode());
      }
      _box.put('_initialized', 'true');
    }
    return _box.values
        .where((v) => v != 'true') // skip sentinel
        .map(ModifierOption.decode)
        .toList();
  }

  List<ModifierOption> _readAll() {
    return _box.values
        .where((v) => v != 'true')
        .map(ModifierOption.decode)
        .toList();
  }

  void add(ModifierOption option) {
    final key = 'f_${DateTime.now().millisecondsSinceEpoch}';
    _box.put(key, option.encode());
    state = _readAll();
  }

  void remove(String name) {
    final keyToRemove = _box.keys.cast<String>().firstWhere(
          (key) {
            if (key == '_initialized') return false;
            final opt = ModifierOption.decode(_box.get(key)!);
            return opt.name == name;
          },
          orElse: () => '',
        );
    if (keyToRemove.isNotEmpty) {
      _box.delete(keyToRemove);
      state = _readAll();
    }
  }

  void update(String oldName, ModifierOption updated) {
    final keyToUpdate = _box.keys.cast<String>().firstWhere(
          (key) {
            if (key == '_initialized') return false;
            final opt = ModifierOption.decode(_box.get(key)!);
            return opt.name == oldName;
          },
          orElse: () => '',
        );
    if (keyToUpdate.isNotEmpty) {
      _box.put(keyToUpdate, updated.encode());
      state = _readAll();
    }
  }
}
