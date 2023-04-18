import 'package:flutter/material.dart';
import 'dart:ui';

class CustomPageRoute extends PageRoute {
  CustomPageRoute({
    required WidgetBuilder builder,
    super.fullscreenDialog,
    super.settings,
  }) : _builder = builder;

  final WidgetBuilder _builder;

  @override
  Color? get barrierColor => Colors.black12;

  @override
  String? get barrierLabel => 'Custom page route';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;
}

/// {@template custom_rect_tween}
/// Linear RectTween with a [Curves.easeOut] curve.
///
/// Less dramatic that the regular [RectTween] used in [Hero] animations.
/// {@endtemplate}
class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    super.begin,
    super.end,
  });

  @override
  Rect? lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin?.left, end?.left, elasticCurveValue)!,
      lerpDouble(begin?.top, end?.top, elasticCurveValue)!,
      lerpDouble(begin?.right, end?.right, elasticCurveValue)!,
      lerpDouble(begin?.bottom, end?.bottom, elasticCurveValue)!,
    );
  }
}
