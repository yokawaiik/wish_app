import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../global/extensions/wish_color.dart';
import '../../global/models/light_wish.dart';
import '../../global/widgets/account_user_avatar.dart';
import '../../global/theme/theme_wish_app.dart' as theme_wish_app;

class SearchListTile extends StatelessWidget {
  final Key? key;
  final String? label;
  final bool enabled;

  final void Function()? onTap;
  final void Function(BuildContext)? slideActionOnPressedDelete;
  final Widget leading;
  final Widget title;

  const SearchListTile({
    required this.leading,
    required this.title,
    this.key,
    this.onTap,
    this.slideActionOnPressedDelete,
    this.label,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enabled,
      key: key,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: slideActionOnPressedDelete,
            backgroundColor: theme_wish_app.removeItemColor,
            icon: Icons.delete,
            label: label,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: leading,
            title: title,
          ),
        ),
      ),
    );
  }
}
