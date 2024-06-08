import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../shared/widgets/features/order_cart/order_cart.notifier.dart";
import "../routes.dart";

class CampusRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final ProviderContainer container;

  CampusRouteObserver(this.container);

  void _resetCart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      container.read(cartProvider.notifier).resetCart();
    });
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name?.startsWith("${AppRoutes.campus}/") == true) {
      print("Navigated to Campus");
      _resetCart();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name?.startsWith("${AppRoutes.campus}/") ==
        true) {
      print("Returned to Campus");
      _resetCart();
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute?.settings.name?.startsWith("${AppRoutes.campus}/") == true) {
      print("Replaced route with Campus");
      _resetCart();
    }
  }
}
