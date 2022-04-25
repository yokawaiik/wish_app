
class WishForm {
  String? id;
  String? imageUrl;
  String? title;
  String? description;
  String? link;
  DateTime? createdAt;

  WishForm({
    this.title,
    this.description,
    this.link,
  });

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "description": description,
      "link": link,
      "imageUrl": imageUrl,
    };
  }

  WishForm.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    imageUrl = data["imageUrl"];
    title = data["title"];
    description = data["description"];
    link = data["link"];
    createdAt = DateTime.fromMillisecondsSinceEpoch(data["createdAt"]);
  }
}
