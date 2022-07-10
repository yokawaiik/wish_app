import 'package:flutter/material.dart';
import 'package:wish_app/src/models/wish.dart';

import '../constants/global_constants.dart' as global_constants;

class WishCard extends StatelessWidget {
  // final double defaultPadding;
  final Wish wish;
  final double radius;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final void Function(TapDownDetails)? onTapDown;

  const WishCard(
    this.wish, {
    Key? key,
    // this.defaultPadding = global_constants.defaultPadding,
    this.radius = global_constants.defaultRadius,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(global_constants.defaultPadding / 2),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        onTapDown: onTapDown,
        highlightColor: colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(global_constants.defaultPadding / 2),
          child: Row(
            children: [
              Container(
                height: 120,
                width: 120,
                clipBehavior: Clip.antiAlias,
                child: wish.imageUrl != null
                    ? Image.network(
                        wish.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.question_mark,
                        size: 50,
                        color: colorScheme.onPrimary,
                      ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(radius),
                  ),
                ),
              ),
              const SizedBox(
                width: global_constants.defaultPadding / 2,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wish.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: textTheme.bodyText1,
                    ),
                    if (wish.description != null)
                      Text(
                        wish.description!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: textTheme.bodyText1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
