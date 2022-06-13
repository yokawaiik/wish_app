import 'package:flutter/material.dart';
import 'package:wish_app/src/extensions/wish_color.dart';

import '../models/wish.dart';

import '../theme/theme_wish_app.dart' as theme_wish_app;

class GridWishItem extends StatelessWidget {
  final double gridItemHeight;
  final Wish wish;
  final Function() onPressedMore;
  final Function() onPressedAddToFavorites;
  final Function() onPressedShare;

  Function()? clickOnWish;
  Function()? onLongPress;
  Function()? clickOnAuthor;

  GridWishItem({
    Key? key,
    required this.gridItemHeight,
    required this.wish,
    required this.onPressedMore,
    required this.onPressedAddToFavorites,
    required this.onPressedShare,
    required this.clickOnWish,
    required this.onLongPress,
    required this.clickOnAuthor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    var colorScheme = Theme.of(context).colorScheme;

    // final headerSectionParts = gridItemHeight * (1 / 10);
    const parts = 10;
    final headerSectionParts = gridItemHeight * (1 / parts);
    final contentSectionParts = gridItemHeight * (7 / parts);
    // final contentSectionParts = 300.00;
    final footerSectionParts = gridItemHeight * (2 / parts);

    // print("GridWishItem - gridItemHeight : $gridItemHeight");
    // print(
    //     "GridWishItem - Sum is: ${headerSectionParts + contentSectionParts + footerSectionParts}");
    // print("GridWishItem - headerSectionParts : $headerSectionParts");
    // print("GridWishItem - contentSectionParts : $contentSectionParts");
    // print("GridWishItem - footerSectionParts : $footerSectionParts");

    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              height: headerSectionParts,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: clickOnAuthor,
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: wish.createdBy.userColor != null
                              ? WishColor.fromHex(wish.createdBy.userColor!)
                              : Theme.of(context).colorScheme.primary,
                          backgroundImage: wish.createdBy.imageUrl != null
                              ? NetworkImage(
                                  wish.createdBy.imageUrl!,
                                )
                              : null,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          wish.createdBy.login,
                          style: TextStyle(
                            fontSize: textTheme.bodyText1!.fontSize,
                            // fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onPressedMore,
                      icon: Icon(Icons.more_horiz)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: clickOnWish,
            child: Container(
              // height: gridItemHeight * 1 / 3,
              height: contentSectionParts,
              width: double.infinity,
              child: wish.hasImage
                  ? Image.network(
                      wish.imageUrl!,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: colorScheme.secondaryContainer,
                      child: Icon(
                        Icons.tag_faces_rounded,
                        size: 100,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            iconSize: 36,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            // todo: add to favorite
                            onPressed: onPressedAddToFavorites,
                            icon: Icon(Icons.star_border_outlined),
                          ),
                          IconButton(
                            iconSize: 36,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.zero,
                            // todo: share
                            onPressed: onPressedShare,
                            icon: Icon(Icons.send),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // todo: add Likes Count
                      // Text(
                      //   "LikesCount",
                      //   style: TextStyle(
                      //     fontSize: textTheme.bodyText1!.fontSize,
                      //     // fontSize: 10,
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        wish.title,
                        style: TextStyle(
                          fontSize: textTheme.bodyText1!.fontSize,
                          // fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
