import 'package:flutter/material.dart';

class BouncingIconButton extends StatefulWidget {
  final void Function()? onTap;

  const BouncingIconButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<BouncingIconButton> createState() => _BouncingIconButtonState();
}

class _BouncingIconButtonState extends State<BouncingIconButton>
    with SingleTickerProviderStateMixin {
  double? _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(
        scale: _scale,
        child: const Icon(Icons.more_horiz),
      ),
      onTapCancel: () {
        if (_controller.status == AnimationStatus.forward ||
            _controller.status == AnimationStatus.completed) {
          _tapUp(null);
        }
      },
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails? details) {
    _controller.reverse();
  }
}
