// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_options_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VesselOptionsRepository)
final vesselOptionsRepositoryProvider = VesselOptionsRepositoryProvider._();

final class VesselOptionsRepositoryProvider
    extends $NotifierProvider<VesselOptionsRepository, List<ModifierOption>> {
  VesselOptionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vesselOptionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vesselOptionsRepositoryHash();

  @$internal
  @override
  VesselOptionsRepository create() => VesselOptionsRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ModifierOption> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ModifierOption>>(value),
    );
  }
}

String _$vesselOptionsRepositoryHash() =>
    r'f3980228b6d7c75dfce9eeb2f004ca8be67cb70d';

abstract class _$VesselOptionsRepository
    extends $Notifier<List<ModifierOption>> {
  List<ModifierOption> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ModifierOption>, List<ModifierOption>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ModifierOption>, List<ModifierOption>>,
              List<ModifierOption>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FlavorOptionsRepository)
final flavorOptionsRepositoryProvider = FlavorOptionsRepositoryProvider._();

final class FlavorOptionsRepositoryProvider
    extends $NotifierProvider<FlavorOptionsRepository, List<ModifierOption>> {
  FlavorOptionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flavorOptionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flavorOptionsRepositoryHash();

  @$internal
  @override
  FlavorOptionsRepository create() => FlavorOptionsRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ModifierOption> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ModifierOption>>(value),
    );
  }
}

String _$flavorOptionsRepositoryHash() =>
    r'3be41f66d3f0da31330efd1dd0d895be47dccdfc';

abstract class _$FlavorOptionsRepository
    extends $Notifier<List<ModifierOption>> {
  List<ModifierOption> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ModifierOption>, List<ModifierOption>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ModifierOption>, List<ModifierOption>>,
              List<ModifierOption>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
