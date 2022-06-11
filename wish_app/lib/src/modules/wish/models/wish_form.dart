import 'dart:io';

class WishForm {
  int? id;

  String? imageUrl;
  File? image;

  String? title;
  String? description;
  String? link;
  DateTime? createdAt;

  String? createdBy;

  late bool wasImageUpdate;
  // String? imagePath;

  bool get hasImage {
    if (imageUrl != null || image != null) return true;
    return false;
  }

  WishForm({
    this.id,
    this.title,
    this.description,
    this.link,
    this.imageUrl,
    this.createdBy,
    this.wasImageUpdate = false,
    // this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "link": link,
      "imageUrl": imageUrl,
      "createdBy": createdBy,
    };
  }

  WishForm.fromJson(Map<String, dynamic> data, String inCreatedBy) {
    id = data["id"];
    imageUrl = data["imageUrl"];
    title = data["title"];
    description = data["description"];
    link = data["link"];
    createdAt = DateTime.fromMillisecondsSinceEpoch(data["createdAt"]);
    createdBy = inCreatedBy;
    wasImageUpdate = false;
    // imagePath = data["imagePath"];
  }
}
