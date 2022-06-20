class UserAccount {
  late String id;
  late String login;
  late String? imageUrl;
  late String? userColor;
  late bool isCurrentUser;

  int? countOfWishes;
  int? countOfsubscribers;
  int? countOfSubscribing;

  bool hasSubscribe = false;
  bool hasSubscription = false;

  UserAccount({
    required this.id,
    required this.login,
    this.imageUrl,
    this.userColor,
    this.isCurrentUser = false,
    this.hasSubscribe = false,
    this.hasSubscription = false,
  });

  UserAccount.fromJson(Map<String, dynamic> data, String? currentUser) {
    id = data["id"];
    login = data["login"];
    imageUrl = data["imageUrl"];
    userColor = data["userColor"];
    isCurrentUser = id == currentUser;
    hasSubscribe = data["has_subscribe"] ?? false;
    hasSubscription = data["has_subscription"] ?? false;
  }

  @override
  String toString() {
    return toMap().toString();
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "login": login,
      "imageUrl": imageUrl,
      "userColor": userColor,
      "isCurrentUser": isCurrentUser,
    };
  }

  void setUserInfoFromMap(Map<String, dynamic> data) {
    countOfWishes = data['count_of_wishes'];
    countOfsubscribers = data['count_of_subscribers'];
    countOfSubscribing = data['count_of_subscribing'];
  }

  void setSubscriptionInfoFromMap(Map<String, dynamic> data) {
    // print("setSubscriptionInfoFromMap - data: $data");
    hasSubscribe = data["has_subscribe"] ?? false;
    hasSubscription = data["has_subscription"] ?? false;
  }
}
