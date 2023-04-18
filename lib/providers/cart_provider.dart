import 'package:flutter/material.dart';
import 'package:kyla_test/core/core.dart';

class CartProvider extends ChangeNotifier {
  final Map<Sneaker, int> _sneakers = {};

  Map<Sneaker, int> get sneakers => _sneakers;

  void addSneaker(Sneaker sneaker) {
    if (_sneakers.containsKey(sneaker)) {
      _sneakers[sneaker] = _sneakers[sneaker]! + 1;
    } else {
      _sneakers[sneaker] = 1;
    }
    notifyListeners();
  }

  void removeSneaker(Sneaker sneaker) {
    if (!_sneakers.containsKey(sneaker)) return;

    if (_sneakers[sneaker] == 1) {
      _sneakers.remove(sneaker);
    } else {
      _sneakers[sneaker] = _sneakers[sneaker]! - 1;
    }

    notifyListeners();
  }
}

extension SneakersMapX on Map<Sneaker, int> {
  int get amount => values.fold(0, (a, b) => a + b);

  double get total => entries.fold(0, (a, b) => a + (b.key.price * b.value));
}
