// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_analytics_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminAnalytics)
final adminAnalyticsProvider = AdminAnalyticsProvider._();

final class AdminAnalyticsProvider
    extends $FunctionalProvider<AnalyticsData, AnalyticsData, AnalyticsData>
    with $Provider<AnalyticsData> {
  AdminAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAnalyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAnalyticsHash();

  @$internal
  @override
  $ProviderElement<AnalyticsData> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AnalyticsData create(Ref ref) {
    return adminAnalytics(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsData>(value),
    );
  }
}

String _$adminAnalyticsHash() => r'92fd088c1fa1d04496b7e91bf8ba1eef77e8ddee';
