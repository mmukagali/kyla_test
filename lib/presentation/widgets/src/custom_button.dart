import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.child,
    this.text,
  }) : assert(
          text == null && child != null || text != null && child == null,
        );

  final VoidCallback onTap;
  final Widget? child;
  final String? text;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
  late final Animation<double> animation = Tween<double>(
    begin: 1,
    end: 0.9,
  ).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return ScaleTransition(
          scale: animation,
          child: GestureDetector(
            onTapDown: (_) => animationController.forward(),
            onTapUp: (_) => animationController.reverse(),
            onTapCancel: () => animationController.reverse(),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
                onPressed: () {
                  animationController
                      .forward()
                      .then((value) => animationController.reverse());
                  Future.delayed(
                    const Duration(milliseconds: 200),
                    widget.onTap,
                  );
                },
                child: widget.text != null
                    ? Text(
                        widget.text!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : widget.child!,
              ),
            ),
          ),
        );
      },
    );
  }
}
