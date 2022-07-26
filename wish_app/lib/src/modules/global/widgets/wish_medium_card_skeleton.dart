import 'package:flutter/material.dart';

import '../constants/global_constants.dart' as global_constants;
import 'skeleton.dart';

class WishMediumCardSkeleton extends StatelessWidget {
  final double imageHeight;

  bool hasActions;

  WishMediumCardSkeleton({
    Key? key,
    this.hasActions = false,
    this.imageHeight = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      key: key,
      padding: const EdgeInsets.all(global_constants.defaultPadding / 2),
      child: Container(
        padding: const EdgeInsets.all(global_constants.defaultPadding / 2),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Skeleton(
              height: imageHeight,
              width: double.infinity,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasActions) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        IconButton(
                          onPressed: null,
                          icon: Icon(Icons.favorite),
                          iconSize: 36,
                        ),
                        IconButton(
                          onPressed: null,
                          icon: Icon(Icons.more_horiz),
                          iconSize: 36,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: global_constants.defaultPadding,
                    ),
                  ] else
                    const SizedBox.shrink(),
                  Skeleton(
                    width: 160,
                  ),
                  const SizedBox(
                    height: global_constants.defaultPadding / 2,
                  ),
                  Skeleton(),
                  const SizedBox(
                    height: global_constants.defaultPadding / 2,
                  ),
                  Skeleton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
