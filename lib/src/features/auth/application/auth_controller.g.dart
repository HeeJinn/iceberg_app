// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

final class AuthControllerProvider
    extends $NotifierProvider<AuthController, StaffMember?> {
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StaffMember? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StaffMember?>(value),
    );
  }
}

String _$authControllerHash() => r'85d3039e06c74f16ffd28422632231bfd27495cb';

abstract class _$AuthController extends $Notifier<StaffMember?> {
  StaffMember? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StaffMember?, StaffMember?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StaffMember?, StaffMember?>,
              StaffMember?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
