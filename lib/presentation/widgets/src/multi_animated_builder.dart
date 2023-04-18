import 'package:flutter/material.dart';

class MultiAnimatedBuilder extends StatelessWidget {
  const MultiAnimatedBuilder({
    super.key,
    required this.animations,
    required this.builder,
  }) : assert(animations.length < 5 && animations.length > 0);
  final List<Animation<dynamic>> animations;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    switch (animations.length) {
      case 1:
        return AnimatedBuilder(
          animation: animations[0],
          builder: (context, _) => builder(context),
        );
      case 2:
        return AnimatedBuilder(
          animation: animations[0],
          builder: (context, _) {
            return AnimatedBuilder(
              animation: animations[1],
              builder: (context, _) => builder(context),
            );
          },
        );
      case 3:
        return AnimatedBuilder(
          animation: animations[0],
          builder: (context, _) {
            return AnimatedBuilder(
              animation: animations[1],
              builder: (context, _) {
                return AnimatedBuilder(
                  animation: animations[2],
                  builder: (context, _) => builder(context),
                );
              },
            );
          },
        );
      case 4:
        return AnimatedBuilder(
          animation: animations[0],
          builder: (context, _) {
            return AnimatedBuilder(
              animation: animations[1],
              builder: (context, _) {
                return AnimatedBuilder(
                  animation: animations[2],
                  builder: (context, _) => AnimatedBuilder(
                    animation: animations[3],
                    builder: (context, _) => builder(context),
                  ),
                );
              },
            );
          },
        );
      default:
        return AnimatedBuilder(
          animation: animations[0],
          builder: (context, _) => builder(context),
        );
    }
  }
}
