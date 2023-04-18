import 'package:flutter/material.dart';
import 'package:kyla_test/core/core.dart';
import 'package:kyla_test/presentation/presentation.dart';

const brands = ['Nike', 'Adidas', 'Jordan', 'Puma', 'Reebok'];

final sneakers = [
  const Sneaker(
    name: 'Epic React',
    brand: 'Nike',
    price: 150.0,
    image: 'assets/temp/sneaker_01.png',
    cardColor: '#40C4FF',
  ),
  const Sneaker(
    name: 'Air Max',
    brand: 'Nike',
    price: 170.0,
    image: 'assets/temp/sneaker_02.png',
    cardColor: '#EA80FC',
  ),
  const Sneaker(
    name: 'Air-270',
    brand: 'Nike',
    price: 100.0,
    image: 'assets/temp/sneaker_03.png',
    cardColor: '#1B5E20',
  ),
  const Sneaker(
    name: 'Air Force',
    brand: 'Nike',
    price: 200.0,
    image: 'assets/temp/sneaker_04.png',
    cardColor: '#2196F3',
  ),
];

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  late final ScrollController scrollController = ScrollController();
  int centeredIndex = 0;
  bool isScrolling = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: hPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 30,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: hPadding),
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemBuilder: (_, index) {
                  return Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    child: Text(
                      brands[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: index == 0 ? Colors.black : Colors.black26,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: sneakersCarouselHeight + 40,
              child: Stack(
                children: [
                  GestureDetector(
                    onPanEnd: (details) {
                      if (isScrolling) return;
                      final dx = details.velocity.pixelsPerSecond.dx;

                      double? nextPage;

                      if (dx > 0) {
                        if (centeredIndex == 0) return;
                        scrollController.animateTo(
                          (centeredIndex - 1) *
                              (sneakerCarouselCardWidth +
                                  sneakerCarouselDivider),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutQuad,
                        );
                        nextPage = centeredIndex - 1;
                      } else if (dx < 0) {
                        if (centeredIndex == 7) return;
                        scrollController.animateTo(
                          (centeredIndex + 1) *
                              (sneakerCarouselCardWidth +
                                  sneakerCarouselDivider),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutQuad,
                        );
                        nextPage = centeredIndex + 1;
                      } else {
                        nextPage = null;
                      }
                      if (nextPage == null) return;
                      centeredIndex = nextPage.floor();
                      setState(() {});
                    },
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          if (isScrolling) return false;
                          isScrolling = true;
                          setState(() {});
                        } else if (notification is ScrollEndNotification) {
                          if (!isScrolling) return false;
                          isScrolling = false;
                          setState(() {});
                        }
                        return false;
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 100,
                          right: sneakerCarouselDivider,
                          top: 20,
                          bottom: 20,
                        ),
                        controller: scrollController,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(15, (i) {
                            if (i.isOdd) {
                              return const SizedBox(
                                  width: sneakerCarouselDivider);
                            }

                            final index = i ~/ 2;
                            return SneakerCarouselCard(
                              index: index,
                              centeredIndex: centeredIndex,
                              sneaker: [...sneakers, ...sneakers][index],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Container(
                      height: 80,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            'New',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black26,
                            ),
                          ),
                          Text(
                            'Forward',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Upcoming',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const SneakersGridList(),
          ],
        ),
      ),
    );
  }
}

class SneakersGridList extends StatelessWidget {
  const SneakersGridList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: hPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('More',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
              Icon(Icons.arrow_forward),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: SneakerGridCard(sneaker: sneakers[2])),
              const SizedBox(width: 15),
              Expanded(child: SneakerGridCard(sneaker: sneakers[1])),
            ],
          ),
        ],
      ),
    );
  }
}
