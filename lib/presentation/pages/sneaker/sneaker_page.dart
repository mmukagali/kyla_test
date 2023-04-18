import 'package:flutter/material.dart';
import 'package:kyla_test/core/constants.dart';
import 'package:kyla_test/presentation/widgets/src/custom_button.dart';
import 'package:kyla_test/core/animations/custom_page_route.dart';
import 'package:kyla_test/core/extensions.dart';
import 'package:kyla_test/core/models/sneaker.dart';
import 'package:kyla_test/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class SneakerPage extends StatefulWidget {
  const SneakerPage({super.key, required this.sneaker, required this.index});

  final Sneaker sneaker;
  final int index;

  static Future<void> route(
    BuildContext context, {
    required Sneaker sneaker,
    required int index,
  }) =>
      Navigator.of(context).push(
        CustomPageRoute(
          builder: (_) => SneakerPage(
            sneaker: sneaker,
            index: index,
          ),
        ),
      );

  @override
  State<SneakerPage> createState() => _SneakerPageState();
}

class _SneakerPageState extends State<SneakerPage>
    with TickerProviderStateMixin {
  late final AnimationController startAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<double> startAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(
    CurvedAnimation(
      parent: startAnimationController,
      curve: Curves.easeIn,
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(
      const Duration(milliseconds: 300),
      startAnimationController.forward,
    );
  }

  @override
  void dispose() {
    startAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: startAnimation,
        builder: (context, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Hero(
                        tag: cardHeroTag(widget.index),
                        createRectTween: (b, e) =>
                            CustomRectTween(begin: b, end: e),
                        child: ClipPath(
                          clipper: HeaderArcClipper(),
                          child: Container(
                            height: 350,
                            color: widget.sneaker.cardColor.getColor(),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeTransition(
                              opacity: startAnimation,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: Navigator.of(context).pop,
                                    icon: const Icon(
                                      Icons.arrow_back_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    widget.sneaker.brand,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          widget.sneaker.cardColor.getColor(),
                                      shape: const CircleBorder(),
                                      elevation: 2,
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border_outlined,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).viewPadding.top,
                        ),
                        child: Hero(
                          tag: sneakerHeroTag(widget.index),
                          createRectTween: (begin, end) =>
                              CustomRectTween(begin: begin, end: end),
                          child: Image.asset(
                            widget.sneaker.image,
                            width: MediaQuery.of(context).size.width * .8,
                          ),
                        ),
                      )
                    ],
                  ),
                  FadeTransition(
                    opacity: startAnimation,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Tween<double>(begin: 50, end: 0)
                            .animate(CurvedAnimation(
                              parent: startAnimation,
                              curve: Curves.easeOut,
                            ))
                            .value,
                      ),
                      child: SneakerContent(sneaker: widget.sneaker),
                    ),
                  ),
                ],
              ),
              FadeTransition(
                opacity: startAnimation,
                child: Container(
                  height: 40 + 50,
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewPadding.bottom,
                  ),
                  padding: EdgeInsets.only(
                    top: Tween<double>(begin: 50, end: 0)
                        .animate(startAnimation)
                        .value,
                    left: hPadding * 2,
                    right: hPadding * 2,
                  ),
                  child: Center(
                    child: CustomButton(
                      onTap: () {
                        context.read<CartProvider>().addSneaker(widget.sneaker);
                      },
                      text: 'Add to bag'.toUpperCase(),
                      child: null,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SneakerContent extends StatefulWidget {
  const SneakerContent({super.key, required this.sneaker});
  final Sneaker sneaker;

  @override
  State<SneakerContent> createState() => _SneakerContentState();
}

class _SneakerContentState extends State<SneakerContent> {
  late final ValueNotifier<double?> sizeNotifier = ValueNotifier(null);

  @override
  void dispose() {
    sizeNotifier.dispose();
    super.dispose();
  }

  static const sizes = [7.0, 7.5, 8.0, 8.5, 9.0, 9.5];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: hPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: List.generate(
                  4,
                  (index) => Expanded(child: Image.asset(widget.sneaker.image)),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 2, thickness: 2, color: Colors.black12),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.sneaker.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${widget.sneaker.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('Some text about sneaker.' * 5),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'UA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'USA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: sizeNotifier,
          builder: (context, selected, _) {
            return SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                scrollDirection: Axis.horizontal,
                itemCount: sizes.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(width: 0.5, color: Colors.black12),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Try it', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 5),
                          Icon(Icons.my_location_outlined, size: 15),
                        ],
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      if (sizes[index - 1] == selected) return;
                      sizeNotifier.value = sizes[index - 1];
                    },
                    child: AnimatedContainer(
                      height: 40,
                      width: 80,
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(width: 0.5, color: Colors.black12),
                        color: sizes[index - 1] == selected
                            ? Colors.black87
                            : Theme.of(context).scaffoldBackgroundColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        sizes[index - 1].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: sizes[index - 1] == selected
                              ? Colors.white
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class HeaderArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const minSize = 150.0;
    // final p1Diff = ((minSize - size.height) * 1.5).truncate().abs();

    path.lineTo(0, size.height * 0.4);
    // path.lineTo(size.width, 350);
    path.arcToPoint(
      Offset(size.width, size.height * .9),
      radius: const Radius.circular(300),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}
