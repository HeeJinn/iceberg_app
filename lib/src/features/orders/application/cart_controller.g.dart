// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CartController)
final cartControllerProvider = CartControllerProvider._();

final class CartControllerProvider
    extends $NotifierProvider<CartController, Order> {
  CartControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartControllerHash();

  @$internal
  @override
  CartController create() => CartController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Order value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Order>(value),
    );
  }
}

String _$cartControllerHash() => r'02857ffc35325dab2a2288d616a92ddf1acbb264';

abstract class _$CartController extends $Notifier<Order> {
  Order build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Order, Order>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Order, Order>,
              Order,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
