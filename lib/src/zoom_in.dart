import 'package:flutter/material.dart';

class ZoomIn extends StatefulWidget {
  final Key key;
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Function(AnimationController) controller;
  final bool manualTrigger;
  final bool animate;
  final double from;

  ZoomIn(
      {this.key,
        this.child,
        this.duration = const Duration(milliseconds: 500),
        this.delay = const Duration(milliseconds: 0),
        this.controller,
        this.manualTrigger = false,
        this.animate = true,
        this.from = 1.0})
      : super(key: key) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  _ZoomInState createState() => _ZoomInState();
}

class _ZoomInState extends State<ZoomIn> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> fade;
  Animation<double> opacity;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);
    fade = Tween(begin: 0.0, end: widget.from)
        .animate(CurvedAnimation(curve: Curves.fastOutSlowIn, parent: controller));

    opacity = Tween<double>(begin: 0.0, end: 1)
        .animate(CurvedAnimation(parent: controller, curve: Interval(0, 0.65)));

    if (!widget.manualTrigger && widget.animate) {
//      Future.delayed(widget.delay, () => controller?.forward());
    }

    if (widget.controller is Function) {
      widget.controller(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate && widget.delay.inMilliseconds == 0) {
      controller?.forward();
    }

    return AnimatedBuilder(
        animation: fade,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: fade.value,
            child: Opacity(
              opacity: opacity.value,
              child: widget.child,
            ),
          );
        });
  }
}
