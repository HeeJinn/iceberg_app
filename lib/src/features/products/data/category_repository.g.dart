// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages user-defined product categories stored in Hive.
/// Default categories are seeded on first launch.

@ProviderFor(CategoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

/// Manages user-defined product categories stored in Hive.
/// Default categories are seeded on first launch.
final class CategoryRepositoryProvider
    extends $NotifierProvider<CategoryRepository, List<String>> {
  /// Manages user-defined product categories stored in Hive.
  /// Default categories are seeded on first launch.
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  CategoryRepository create() => CategoryRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'c47cfb3d0588cc09a6b5eada61dc4e4a497d38f2';

/// Manages user-defined product categories stored in Hive.
/// Default categories are seeded on first launch.

abstract class _$CategoryRepository extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
