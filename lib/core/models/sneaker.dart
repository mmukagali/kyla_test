import 'package:flutter/foundation.dart' show immutable;

@immutable
class Sneaker {
  final String name;
  final String brand;
  final double price;
  final String image;
  final String cardColor;

  const Sneaker({
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.cardColor,
  });
}
