import 'package:flutter/material.dart';

import '../models/wish.dart';

class GridWishItem extends StatelessWidget {
  final double gridItemHeight;
  final Wish wish;

  const GridWishItem({
    Key? key,
    required this.gridItemHeight,
    required this.wish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Container(
            // height: gridItemHeight * 1 / 3,
            height: gridItemHeight * 1 / 3,
            width: double.infinity,
            child: wish.hasImage
                ? Image.network(
                    wish.imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.tag_faces_rounded,
                      size: 100,
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    wish.title,
                    style: TextStyle(
                      fontSize: textTheme.headline5?.fontSize,
                    ),
                  ),
                  IconButton(
                    iconSize: 40,
                    icon: Icon(
                      Icons.favorite,
                    ),
                    onPressed: () {
                      // todo: like action
                    },
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
