import 'package:wish_app/src/models/wish_user.dart';

import '../utils/generate_wish_image_path.dart';

class Wish {
  late int id;
  late String title;
  late String? description;
  late String? link;
  late String? imageUrl;
  late DateTime createdAt;
  late WishUser createdBy;
  // late bool isCurrentUser;

  bool get hasImage => imageUrl != null ? true : false;

  String? get imagePath {
    if (hasImage) {
      final imagePath = generateWishImagePath(
        imageUrl!,
        id.toString(),
      );
      return imagePath;
    }
    return null;
  }

  Wish({
    required this.id,
    required this.title,
    this.description,
    this.link,
    this.imageUrl,
    required this.createdAt,
    required this.createdBy,
    // this.isCurrentUser = false,
  });

  @override
  String toString() {
    return 'Wish: id - $id, title - $title, description - $description, link - $link';
  }

  Wish.fromJson(Map<String, dynamic> data, String? currentUserId) {
    id = data["id"];
    title = data["title"];
    description = data["description"];
    link = data["link"];
    imageUrl = data["imageUrl"];
    createdAt = DateTime.parse(data["createdAt"] as String);

    // only for UI
    createdBy = WishUser(
      id: data["createdBy"],
      login: data["login"],
      imageUrl: data["userImageUrl"],
      userColor: data["userColor"],
      isCurrentUser: data["createdBy"] == currentUserId,
    );
    // isCurrentUser = data["createdBy"] == currentUserId;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "link": link,
      "imageUrl": imageUrl,
      "createdAt": createdAt,
      "createdBy": createdBy,
      // "isCurrentUser": isCurrentUser,
    };
  }
}
