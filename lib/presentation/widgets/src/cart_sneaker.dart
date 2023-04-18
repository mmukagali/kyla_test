import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kyla_test/core/core.dart';
import 'package:kyla_test/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartSneaker extends StatelessWidget {
  const CartSneaker({
    super.key,
    required this.sneaker,
    required this.amount,
    required this.onZeroAmount,
  });
  final Sneaker sneaker;
  final int amount;
  final VoidCallback onZeroAmount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black12,
                    ),
                  ),
                  const SizedBox(width: 60),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sneaker.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '\$${sneaker.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                final isZero = amount == 1;
                                if (isZero) onZeroAmount();

                                context
                                    .read<CartProvider>()
                                    .removeSneaker(sneaker);
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  CupertinoIcons.minus,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              amount.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () => context
                                  .read<CartProvider>()
                                  .addSneaker(sneaker),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  CupertinoIcons.plus,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                sneaker.image,
                height: 160,
                width: 160,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
