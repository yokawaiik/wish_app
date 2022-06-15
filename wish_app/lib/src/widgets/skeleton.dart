import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

enum _ConstructorType {
  basic,
  round,
  elevatedButton,
  square,
}

class Skeleton extends StatelessWidget {
  double? height;
  double? width;
  Color? color;
  double? radius;

  late final _ConstructorType _constructorType;

  // const Skeleton({
  //   Key? key,
  //   required this.height,
  //   required this.width,
  //   this.color,
  //   this.radius,
  // }) : super(key: key);
  Skeleton({
    Key? key,
    this.height = double.infinity,
    this.width = double.infinity,
    this.color,
    this.radius = 15,
  }) : super(key: key) {
    key = key;
    _constructorType = _ConstructorType.basic;
  }

  Skeleton.round({
    this.color,
    required this.radius,
  }) {
    _constructorType = _ConstructorType.round;
  }

  Skeleton.hardCorners({
    this.color,
  }) {
    _constructorType = _ConstructorType.square;
    radius = 0;
  }

  Skeleton.elevatedButton({
    this.color,
    this.width = 100,
    this.height,
  }) {
    _constructorType = _ConstructorType.elevatedButton;
  }

  @override
  Widget build(BuildContext context) {
    color ??= Colors.black.withOpacity(0.05);

    switch (_constructorType) {
      case _ConstructorType.round:
        return CircleAvatar(
          radius: radius,
          backgroundColor: color,
        );
      case _ConstructorType.elevatedButton:
        return SizedBox(
          width: width,
          height: height,
          child: ElevatedButton(
            onPressed: null,
            child: null,
            style: ElevatedButton.styleFrom(
              primary: color,
            ),
          ),
        );
      default:
        return Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color ?? Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.all(
              Radius.circular(radius!),
            ),
          ),
        );
    }
  }
}
