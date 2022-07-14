import 'package:flutter/material.dart';

class ButtonCounterTitle extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final String? counter;
  final double height;
  final double width;
  final Widget? skeleton;

  const ButtonCounterTitle({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.counter,
    this.height = 70,
    this.width = 70,
    this.skeleton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (counter == null && skeleton != null) {
      return skeleton!;
    }

    return SizedBox.fromSize(
      size: Size(width, height), // button width and height
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // counter, // icon
            // title,
            Text(
              counter ?? "Nothing",
              style: TextStyle(
                fontSize: textTheme.headline6!.fontSize,
              ),
            ),
            Text(
              title,
            )
          ],
        ),
      ),
    );
  }
}
