import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

import "../../layout/base_layout.dart";
import "../../shared/widgets/features/header/product-header/products_categories_header.dart";
import "../../shared/widgets/features/order_cart/order_cart.notifier.dart";
import "../../shared/widgets/features/order_cart/order_cart.types.dart";

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const String labelOrderKey = "Cart.labels.CART.label";
    final List<CartItem> cartItems = ref.watch(cartProvider);
    final PersistentTabController controller = PersistentTabController();

    void generateOrder() {
      for (CartItem item in cartItems) {
        print(item.productInfo.toJson());
      }
    }

    return BaseLayout(
      tabController: controller,
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.background,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: CBaseProductCategoriesHeader(
                    title: labelOrderKey.tr(),
                    height: 220,
                    onButtonPressed: (BuildContext context) {
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop();
                      }
                    },
                    fontSize: 32,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: const EdgeInsets.all(8),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 4,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final CartItem item = cartItems[index];
                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          item.productInfo.imageUrl),
                                    ),
                                    title: Text(item.productInfo.productName),
                                    subtitle: Text(
                                      "Cantidad: ${item.quantity}\nPrecio unitario: ${item.productInfo.currency} ${item.productInfo.price.toStringAsFixed(2)}\nTotal: ${item.productInfo.currency} ${(item.quantity * item.productInfo.getTotalPrice()).toStringAsFixed(2)}",
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => ref
                                          .read(cartProvider.notifier)
                                          .removeProduct(
                                              item.productInfo.productId),
                                    ),
                                  ),
                                );
                              },
                              childCount: cartItems.length,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: generateOrder,
                              child: const Text("Generar Orden"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: true,
                  child: Container(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
