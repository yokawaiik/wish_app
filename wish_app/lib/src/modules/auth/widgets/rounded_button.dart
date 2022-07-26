import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final double height;

  final double width;

  final void Function()? onPressed;

  final Widget child;

  const RoundedButton({
    Key? key,
    this.height = 50.0,
    this.width = double.infinity,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          padding: const EdgeInsets.all(0.0),
        ),
        child: Ink(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10.0)),
          child: Container(
              constraints: BoxConstraints(maxWidth: width, minHeight: height),
              alignment: Alignment.center,
              child: child),
        ),
      ),
    );
  }
}
