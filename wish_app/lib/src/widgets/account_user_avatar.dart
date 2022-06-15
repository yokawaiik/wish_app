import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wish_app/src/widgets/skeleton.dart';

import '../extensions/wish_color.dart';

class AccountUserAvatar extends StatelessWidget {
  final Color defaultColor;
  final String? userHexColor;
  final String? imageUrl;
  final double? radius;
  final Widget? skeleton;
  final bool isLoading;

  const AccountUserAvatar({
    Key? key,
    required this.defaultColor,
    required this.userHexColor,
    required this.imageUrl,
    this.radius,
    this.skeleton,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading == false && skeleton != null) {
      return skeleton!;
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: userHexColor != null
          ? WishColor.fromHex(userHexColor!)
          : defaultColor,
      backgroundImage: imageUrl != null
          ? NetworkImage(
              imageUrl!,
            )
          : null,
    );
  }
}
