import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kyla_test/core/core.dart';
import 'package:kyla_test/presentation/presentation.dart';

class SneakerCarouselCard extends StatefulWidget {
  const SneakerCarouselCard({
    super.key,
    required this.index,
    required this.centeredIndex,
    required this.sneaker,
  });
  final int index;
  final int centeredIndex;
  final Sneaker sneaker;

  @override
  State<SneakerCarouselCard> createState() => _SneakerCarouselCardState();
}

class _SneakerCarouselCardState extends State<SneakerCarouselCard>
    with TickerProviderStateMixin {
  late final AnimationController cardRotateAnimationController =
      AnimationController(
    vsync: this,
    reverseDuration: const Duration(milliseconds: 500),
    duration: const Duration(milliseconds: 150),
  );
  late final Animation<double> cardRotateAnimation = Tween<double>(
    begin: 0,
    end: pi / 4,
  ).animate(
    CurvedAnimation(
      parent: cardRotateAnimationController,
      curve: Curves.easeInOut,
      reverseCurve: const Cubic(0.5, -0.48, 0.835, 0.0),
    ),
  );

  late final AnimationController scaleAnimationController = AnimationController(
    value: widget.index == 0 ? 1 : null,
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  late final Animation<double> scaleAnimation = Tween<double>(
    begin: 0.9,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: scaleAnimationController,
      curve: Curves.easeInCubic,
      reverseCurve: Curves.easeIn,
      // curve: Curves.easeOut,
      // reverseCurve: Curves.easeIn,
    ),
  );

  late final AnimationController sneakerRotateAnimationController =
      AnimationController(
    value: widget.index == 0 ? pi : null,
    vsync: this,
    duration: const Duration(milliseconds: 550),
  );
  late final Animation<double> sneakerRotateAnimation = Tween<double>(
    begin: -pi / 7,
    end: 0,
  ).animate(
    CurvedAnimation(
      parent: sneakerRotateAnimationController,
      curve: Curves.easeOut,
    ),
  );

  late final AnimationController sneakerSlideAndScaleAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 400),
  );
  late final Animation<RelativeRect> sneakerSlideAnimation = RelativeRectTween(
    begin: RelativeRect.fromDirectional(
      textDirection: TextDirection.rtl,
      start: 0,
      top: 0,
      end: sneakerCarouselCardMargin * 2,
      bottom: 0,
    ),
    end: RelativeRect.fromDirectional(
      textDirection: TextDirection.rtl,
      start: sneakerCarouselCardMargin * 2,
      top: 0,
      end: 0,
      bottom: 0,
    ),
  ).animate(
    CurvedAnimation(
      parent: sneakerSlideAndScaleAnimationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    ),
  );
  late final Animation<double> sneakerScaleAnimation = Tween<double>(
    begin: 1,
    end: 0.9,
  ).animate(
    CurvedAnimation(
      parent: sneakerSlideAndScaleAnimationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeOut,
    ),
  );

  late final AnimationController tapAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    reverseDuration: const Duration(milliseconds: 200),
  );
  late final Animation<double> tapAnimation = Tween<double>(
    begin: 1,
    end: 0.9,
  ).animate(
    CurvedAnimation(
      parent: tapAnimationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.elasticIn,
    ),
  );

  late final StreamController<bool> tapStream = StreamController()
    ..stream.listen((pressing) {
      if (pressing) {
        tapAnimationController.forward();
      } else {
        tapAnimationController.reverse();
      }
    });

  @override
  void didUpdateWidget(covariant SneakerCarouselCard oldWidget) {
    final oldIndex = oldWidget.centeredIndex;
    final newIndex = widget.centeredIndex;

    final index = widget.index;

    if (oldIndex == newIndex) return;

//     print('''

//         ----------
//         CARD        --> $index
//         OLD INDEX   --> $oldIndex
//         NEW INDEX   --> $newIndex
//         ----------

// ''');

    if (newIndex == index && oldIndex < index) {
      cardRotateAnimationController.forward().then((_) => Future.delayed(
            const Duration(milliseconds: 100),
            cardRotateAnimationController.reverse,
          ));
    }

    if (oldIndex != index && newIndex == index) {
      // cardRotateAnimationController.forward().then((_) => Future.delayed(
      //       const Duration(milliseconds: 100),
      //       cardRotateAnimationController.reverse,
      //     ));
      sneakerRotateAnimationController.forward();
    }

    if (oldIndex < index && newIndex == index) {
      scaleAnimationController.forward();
    }

    if (oldIndex == index && newIndex < index) {
      scaleAnimationController.reverse();
      sneakerRotateAnimationController.reverse();
    }

    if (newIndex == index && oldIndex > index) {
      sneakerSlideAndScaleAnimationController.reverse();
    }

    if (oldIndex == index && newIndex > index) {
      sneakerSlideAndScaleAnimationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    cardRotateAnimationController.dispose();
    scaleAnimationController.dispose();
    sneakerRotateAnimationController.dispose();
    sneakerSlideAndScaleAnimationController.dispose();
    tapAnimationController.dispose();
    tapStream.close();
    super.dispose();
  }

  static Matrix4 _pmat(num pv) {
    return Matrix4(
      1.0, 0.0, 0.0, 0.0, //
      0.0, 1.0, 0.0, 0.0, //
      0.0, 0.0, 1.0, pv * 0.001, //
      0.0, 0.0, 0.0, 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapCancel: () => tapStream.add(false),
      onTapDown: (_) => tapStream.add(true),
      onTapUp: (_) => tapStream.add(false),
      onTap: () {
        tapStream.add(true);
        Future.delayed(const Duration(milliseconds: 200), () {
          tapStream.add(false);
          SneakerPage.route(
            context,
            sneaker: widget.sneaker,
            index: widget.index,
          );
        });
      },
      child: MultiAnimatedBuilder(
        animations: [scaleAnimation, cardRotateAnimation],
        builder: (context) {
          return ScaleTransition(
            scale: scaleAnimation,
            child: SizedBox(
              height: sneakersCarouselHeight,
              width: sneakerCarouselCardWidth,
              child: Stack(
                children: [
                  Transform(
                    transform: _pmat(1)..rotateY(cardRotateAnimation.value),
                    alignment: Alignment.center,
                    child: Hero(
                      tag: cardHeroTag(widget.index),
                      createRectTween: (b, e) =>
                          CustomRectTween(begin: b, end: e),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          height: sneakersCarouselHeight,
                          margin: const EdgeInsets.only(
                            left: sneakerCarouselCardMargin,
                            right: sneakerCarouselCardMargin,
                          ),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: widget.sneaker.cardColor.getColor(),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.sneaker.brand.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    widget.sneaker.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '\$${widget.sneaker.price}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  MultiAnimatedBuilder(
                    animations: [
                      tapAnimation,
                      sneakerScaleAnimation,
                      sneakerSlideAnimation,
                      sneakerRotateAnimation
                    ],
                    builder: (context) {
                      return PositionedTransition(
                        rect: sneakerSlideAnimation,
                        child: ScaleTransition(
                          scale: tapAnimation,
                          child: ScaleTransition(
                            scale: sneakerScaleAnimation,
                            child: Transform(
                              transform: Matrix4.identity()
                                ..rotateZ(sneakerRotateAnimation.value),
                              alignment: Alignment.topCenter,
                              child: Center(
                                child: Hero(
                                  tag: sneakerHeroTag(widget.index),
                                  createRectTween: (begin, end) =>
                                      CustomRectTween(begin: begin, end: end),
                                  child: Image.asset(
                                    widget.sneaker.image,
                                    width: sneakerCarouselCardWidth -
                                        sneakerCarouselCardMargin * 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
