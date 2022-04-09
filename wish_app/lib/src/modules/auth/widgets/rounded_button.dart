import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  double height;

  double width;

  void Function()? onPressed;

  String text;

  RoundedButton({
    Key? key,
    this.height = 50.0,
    this.width = double.infinity,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
        ),
        child: Ink(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
