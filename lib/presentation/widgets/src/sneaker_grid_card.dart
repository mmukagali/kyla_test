import 'package:flutter/material.dart';
import 'package:kyla_test/core/constants.dart';
import 'package:kyla_test/core/models/sneaker.dart';

class SneakerGridCard extends StatelessWidget {
  const SneakerGridCard({super.key, required this.sneaker});
  final Sneaker sneaker;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sneakerGridCardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 10,
        right: 10,
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Container(
                  height: 20,
                  width: 80,
                  color: Colors.redAccent,
                  alignment: Alignment.center,
                  child: const Text(
                    'NEW',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Icon(Icons.favorite_border_outlined),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(sneaker.image),
              Text(
                sneaker.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text('\$${sneaker.price}'),
            ],
          ),
        ],
      ),
    );
  }
}
