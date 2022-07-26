import 'package:flutter/material.dart';

class ButtonCounterTitle extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final String? counter;
  final double height;
  final double width;
  final Widget? skeleton;
  final double fontSizeTitle;
  final double fontSizeCounter;

  const ButtonCounterTitle({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.counter,
    this.fontSizeTitle = 11,
    this.fontSizeCounter = 16,
    this.height = 70,
    this.width = 70,
    this.skeleton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (counter == null && skeleton != null) {
      return skeleton!;
    }

    return SizedBox.fromSize(
      size: Size(width, height),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              counter ?? "Nothing",
              style: TextStyle(
                fontSize: fontSizeCounter,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: fontSizeTitle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
