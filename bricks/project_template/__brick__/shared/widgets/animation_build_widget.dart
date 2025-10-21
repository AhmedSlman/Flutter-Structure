import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AnimationAppearance extends StatefulWidget {
  AnimationAppearance(
      {Key? key,
      required this.child,
      this.alignment,
      this.duration,
      this.curve})
      : super(key: key);
  final Widget child;
  final Duration? duration;
  final AlignmentGeometry? alignment;
  final Curve? curve;
  @override
  State<AnimationAppearance> createState() => _AnimationAppearanceState();
}

class _AnimationAppearanceState extends State<AnimationAppearance> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        curve: widget.curve ?? Curves.bounceOut,
        duration: widget.duration ?? Duration(milliseconds: 1200),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, tween, child) {
          return Transform(
              alignment: widget.alignment ?? Alignment.bottomCenter,
              transform: Matrix4.identity()..scale(tween),
              child: widget.child);
        });
  }
}

class AnimationAppearanceDelayed extends StatefulWidget {
  const AnimationAppearanceDelayed(
      {Key? key,
      required this.child,
      this.alignment,
      this.delayed,
      this.duration,
      this.curve})
      : super(key: key);
  final Widget child;
  final Duration? duration;
  final Duration? delayed;
  final AlignmentGeometry? alignment;
  final Curve? curve;
  @override
  State<AnimationAppearanceDelayed> createState() =>
      _AnimationAppearanceDelayedState();
}

class _AnimationAppearanceDelayedState
    extends State<AnimationAppearanceDelayed> {
  Future? delayed;
  @override
  void initState() {
    delayed = Future.delayed(widget.delayed ?? Duration.zero);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: delayed,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? SizedBox()
              : TweenAnimationBuilder<double>(
                  curve: widget.curve ?? Curves.easeInOut,
                  duration: widget.duration ?? Duration(milliseconds: 300),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, tween, child) {
                    return Transform.translate(
                      offset: Offset(0, 100 * (1 - tween)),
                      child: Opacity(
                        opacity: tween,
                        child: widget.child,
                      ),
                    );
                    // return Transform(
                    //     alignment: widget.alignment ?? Alignment.bottomCenter,
                    //     transform: Matrix4.identity()..scale(tween),
                    //     child: widget.child);
                  });
        });
  }
}

class SliverAnimatedBuilder extends StatefulWidget {
  const SliverAnimatedBuilder(
      {Key? key,
      required this.child,
      this.alignment,
      this.delayed,
      this.duration,
      this.curve})
      : super(key: key);
  final Widget child;
  final Duration? duration;
  final Duration? delayed;
  final AlignmentGeometry? alignment;
  final Curve? curve;
  @override
  State<SliverAnimatedBuilder> createState() => _SliverAnimatedBuilderState();
}

class _SliverAnimatedBuilderState extends State<SliverAnimatedBuilder> {
  Future? delayed;
  @override
  void initState() {
    delayed = Future.delayed(widget.delayed ?? Duration.zero);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: delayed,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? SliverToBoxAdapter(child: SizedBox())
              : TweenAnimationBuilder<double>(
                  curve: widget.curve ?? Curves.easeInOut,
                  duration: widget.duration ?? Duration(milliseconds: 300),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, tween, child) {
                    return SliverPadding(
                      padding: EdgeInsets.only(top: 100 * (1 - tween)),
                      sliver: SliverOpacity(
                        opacity: tween,
                        sliver: widget.child,
                      ),
                    );

                    // return Transform(
                    //     alignment: widget.alignment ?? Alignment.bottomCenter,
                    //     transform: Matrix4.identity()..scale(tween),
                    //     child: widget.child);
                  });
        });
  }
}

class AnimationAppearanceOpacity extends StatefulWidget {
  AnimationAppearanceOpacity({Key? key, required this.child, this.duration})
      : super(key: key);
  final Widget child;

  final Duration? duration;
  @override
  State<AnimationAppearanceOpacity> createState() =>
      _AnimationAppearanceOpacityState();
}

class _AnimationAppearanceOpacityState
    extends State<AnimationAppearanceOpacity> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        duration: widget.duration ?? Duration(milliseconds: 1400),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, tween, child) {
          return Opacity(opacity: tween, child: widget.child);
        });
  }
}
