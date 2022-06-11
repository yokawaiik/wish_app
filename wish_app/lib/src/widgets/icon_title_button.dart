import 'package:flutter/material.dart';

class IconTitleButton extends StatelessWidget {
  final Function()? onPressed;
  final Icon icon;
  final Text title;

  const IconTitleButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(60, 60), // button width and height
      child: ClipOval(
        child: Material(
          child: InkWell(
            onTap:  onPressed,
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
