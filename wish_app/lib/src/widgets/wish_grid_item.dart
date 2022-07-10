import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../constants/global_constants.dart' as global_constants;
import '../models/wish.dart';
import 'bouncing_icon_button.dart';

class WishGridItem extends StatelessWidget {
  final Wish wish;

  final Function()? onPressedMore;
  // final Function() onPressedAddToFavorites;
  // final Function() onPressedShare;

  final Function()? clickOnWish;
  final Function()? onLongPress;

  const WishGridItem({
    Key? key,
    required this.wish,
    required this.onPressedMore,
    this.clickOnWish,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Get.textTheme;
    final colorScheme = Get.theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(
        global_constants.defaultRadius,
      ),
      onTap: clickOnWish,
      onLongPress: onLongPress,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                global_constants.defaultRadius,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: wish.imageUrl != null
                ? _ImageNetworkForGridItem(
                    imageUrl: wish.imageUrl!,
                  )
                : Container(
                    color: colorScheme.primary,
                    child: SizedBox(
                      height: 250,
                      child: Icon(
                        Icons.question_mark,
                        color: colorScheme.onPrimary,
                        size: 100,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding:
                const EdgeInsets.all(global_constants.paddingInsideGridView),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    '${wish.title}, ${wish.description}',
                    style: textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                BouncingIconButton(
                  onTap: onPressedMore,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ImageNetworkForGridItem extends StatefulWidget {
  final String imageUrl;
  const _ImageNetworkForGridItem({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<_ImageNetworkForGridItem> createState() =>
      _ImageNetworkForGridItemState();
}

class _ImageNetworkForGridItemState extends State<_ImageNetworkForGridItem> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      fit: BoxFit.contain,
      frameBuilder: (
        _ctx,
        child,
        frame,
        wasSynchronouslyLoaded,
      ) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          child: child,
          opacity: loading ? 0 : 1,
          duration: const Duration(seconds: 3),
          curve: Curves.easeOut,
        );
      },
      loadingBuilder: (
        _ctx,
        child,
        loadingProgress,
      ) {
        if (loadingProgress == null) {
          // The child (AnimatedOpacity) is build with loading == true, and then the setState will
          // change loading to false, which trigger the animation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => loading = false);
          });

          return child;
        }
        loading = true;
        return SizedBox(
          height: 250,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }
}
