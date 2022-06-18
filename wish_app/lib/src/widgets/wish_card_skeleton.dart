import 'package:flutter/material.dart';
import 'package:wish_app/src/widgets/skeleton.dart';

class WishCardSkeleton extends StatelessWidget {
  final double defaultPadding;

  static const double _defaultPadding = 15;

  const WishCardSkeleton({
    Key? key,
    this.defaultPadding = _defaultPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultPadding),
      child: Row(
        children: [
          Skeleton(
            height: 120,
            width: 120,
          ),
          SizedBox(
            width: defaultPadding,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(
                  width: 160,
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Skeleton(),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Skeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
