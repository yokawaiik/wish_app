import 'package:flutter/material.dart';

class IconTitleButton extends StatelessWidget {
  final Function()? onPressed;
  final Icon icon;
  final Text title;
  final double width;
  final double height;

  const IconTitleButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.width = 60,
    this.height = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return SizedBox.fromSize(
    //   size: Size(width, height), // button width and height
    return SizedBox(
      width: width,
      height: height,
      child: ClipOval(
        child: Material(
          child: InkWell(
            onTap: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                icon, // icon
                title, // text
              ],
            ),
          ),
        ),
      ),
    );
  }
}
