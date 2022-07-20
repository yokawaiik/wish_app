import 'package:flutter/material.dart';

import '../extensions/wish_color.dart';

class AccountUserAvatar extends StatelessWidget {
  final Color defaultColor;
  // final String? userHexColor;
  final Color? userColor;
  final String? imageUrl;
  final double? radius;
  final bool isLoading;
  final Icon? iconChild;

  const AccountUserAvatar({
    Key? key,
    required this.defaultColor,
    this.userColor,
    required this.imageUrl,
    this.radius = 60,
    this.isLoading = true,
    this.iconChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius! * 2,
        height: radius! * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius!),
          color: userColor ?? defaultColor,
        ),
        child: imageUrl == null
            ? iconChild
            : Image.network(
                imageUrl!, // ? info: reuired if needs to update widget image
                key: key,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
