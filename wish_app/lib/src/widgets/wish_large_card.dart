import 'package:flutter/material.dart';
import 'package:wish_app/src/widgets/skeleton.dart';

import '../constants/global_constants.dart' as global_constants;
import '../theme/theme_wish_app.dart' as theme_wish_app;

import '../models/wish.dart';

class WishLargeCard extends StatelessWidget {
  final double imageHeight;
  Wish wish;
  bool hasActions;

  final void Function()? onCardTap;
  final void Function()? toggleFavorite;
  final void Function()? tapOnMore;
  final void Function()? onLongPress;

  WishLargeCard({
    Key? key,
    required this.wish,
    this.hasActions = false,
    this.onCardTap,
    this.toggleFavorite,
    this.tapOnMore,
    this.onLongPress,
    this.imageHeight = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      key: key,
      padding: const EdgeInsets.all(global_constants.defaultPadding / 2),
      child: InkWell(
        onLongPress: onLongPress,
        onTap: onCardTap,
        child: Container(
          padding: const EdgeInsets.all(global_constants.defaultPadding / 2),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                height: imageHeight,
                width: double.infinity,
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
                    Radius.circular(global_constants.defaultRadius),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasActions) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: toggleFavorite,
                            icon: const Icon(Icons.favorite),
                            color: wish.isFavorite
                                ? theme_wish_app.favoriteColor
                                : theme_wish_app.unFavoriteColor,
                            iconSize: 36,
                          ),
                          IconButton(
                            onPressed: tapOnMore,
                            icon: const Icon(Icons.more_horiz),
                            iconSize: 36,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: global_constants.defaultPadding,
                      ),
                    ] else
                      const SizedBox.shrink(),
                    Text(
                      wish.title,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headline6,
                      maxLines: 1,
                    ),
                    if (wish.description != null)
                      Text(
                        wish.description!,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headline6,
                        maxLines: 2,
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
