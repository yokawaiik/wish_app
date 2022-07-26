class WishInfoArguments {
  final int wishId;
  final String? previousRouteName;

  WishInfoArguments({
    required this.wishId,
    this.previousRouteName,
  });

  Map<String, dynamic> toMap() {
    return {
      "wishId": wishId,
      "previousRouteName": previousRouteName,
    };
  }
}
