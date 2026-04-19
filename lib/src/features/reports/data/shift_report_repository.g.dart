// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShiftReportRepository)
final shiftReportRepositoryProvider = ShiftReportRepositoryProvider._();

final class ShiftReportRepositoryProvider
    extends $NotifierProvider<ShiftReportRepository, List<ShiftReport>> {
  ShiftReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shiftReportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shiftReportRepositoryHash();

  @$internal
  @override
  ShiftReportRepository create() => ShiftReportRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ShiftReport> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ShiftReport>>(value),
    );
  }
}

String _$shiftReportRepositoryHash() =>
    r'bc8522d8bfa34da42180c5cdfc5ae6e24d37e185';

abstract class _$ShiftReportRepository extends $Notifier<List<ShiftReport>> {
  List<ShiftReport> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ShiftReport>, List<ShiftReport>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ShiftReport>, List<ShiftReport>>,
              List<ShiftReport>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
