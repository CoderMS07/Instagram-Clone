import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final bool isAnimating;
  final VoidCallback? onEnd;
  final bool smalllike;
  const LikeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 150),
    required this.isAnimating,
    this.onEnd,
    this.smalllike = false,
  });

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.isAnimating!=oldWidget.isAnimating){
      startAnimation();
    }
  }

  startAnimation() async{
    if(widget.isAnimating || widget.smalllike){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));

      if(widget.onEnd!=null){
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale, child: widget.child,);
  }
}
