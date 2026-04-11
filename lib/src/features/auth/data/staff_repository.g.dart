// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffRepository)
final staffRepositoryProvider = StaffRepositoryProvider._();

final class StaffRepositoryProvider
    extends $NotifierProvider<StaffRepository, List<StaffMember>> {
  StaffRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffRepositoryHash();

  @$internal
  @override
  StaffRepository create() => StaffRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<StaffMember> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<StaffMember>>(value),
    );
  }
}

String _$staffRepositoryHash() => r'4b61603cadcbc73b7052a4c7a2c0fdd96608a387';

abstract class _$StaffRepository extends $Notifier<List<StaffMember>> {
  List<StaffMember> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<StaffMember>, List<StaffMember>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<StaffMember>, List<StaffMember>>,
              List<StaffMember>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
