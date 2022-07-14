import 'package:flutter/material.dart';

import '../extensions/wish_color.dart';

class AccountUserAvatar extends StatelessWidget {
  final Color defaultColor;
  final String? userHexColor;
  final String? imageUrl;
  final double? radius;
  final bool isLoading;

  const AccountUserAvatar({
    Key? key,
    required this.defaultColor,
    required this.userHexColor,
    required this.imageUrl,
    this.radius = 60,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius! * 2,
        height: radius! * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius!),
          color: userHexColor != null
              ? WishColor.fromHex(userHexColor!)
              : defaultColor,
        ),
        child: imageUrl == null
            ? null
            : Image.network(
                imageUrl!, // ? info: reuired if needs to update widget image
                key: key,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
