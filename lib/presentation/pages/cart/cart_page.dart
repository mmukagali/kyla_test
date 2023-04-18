import 'package:flutter/material.dart';
import 'package:kyla_test/core/core.dart';
import 'package:kyla_test/presentation/widgets/src/cart_sneaker.dart';
import 'package:kyla_test/presentation/widgets/src/custom_button.dart';
import 'package:kyla_test/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Bag',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text('Total ${provider.sneakers.amount} items'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 0.5),
                    child: Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.black.withOpacity(0.04),
                    ),
                  ),
                  Expanded(
                    child: provider.sneakers.isNotEmpty
                        ? SneakersListView(sneakers: provider.sneakers)
                        : const Center(
                            child: Text(
                              'No Items',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 0.5),
                    child: Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.black.withOpacity(0.04),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: hPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${provider.sneakers.total}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: hPadding * 2),
                    child:
                        CustomButton(onTap: () {}, child: null, text: 'NEXT'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SneakersListView extends StatefulWidget {
  const SneakersListView({super.key, required this.sneakers});
  final Map<Sneaker, int> sneakers;

  @override
  State<SneakersListView> createState() => _SneakersListViewState();
}

class _SneakersListViewState extends State<SneakersListView> {
  final listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey,
      padding: const EdgeInsets.symmetric(horizontal: hPadding),
      initialItemCount: widget.sneakers.keys.length,
      itemBuilder: (context, index, _) {
        final sneaker = widget.sneakers.keys.elementAt(index);
        final amount = widget.sneakers[sneaker];
        return Builder(
          builder: (context) {
            return CartSneaker(
              sneaker: sneaker,
              amount: amount ?? 0,
              onZeroAmount: () => listKey.currentState?.removeItem(
                index,
                (context, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: CartSneaker(
                      sneaker: sneaker,
                      amount: amount ?? 0,
                      onZeroAmount: () {},
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
