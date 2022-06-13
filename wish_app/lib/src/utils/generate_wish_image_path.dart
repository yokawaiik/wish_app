String generateWishImagePath(String rawFilePath, String id) {
  final fileExt = rawFilePath.split('.').last;
  final fileName = '${id}.$fileExt'.replaceAll(" ", "");
  final imagePath = "wish/$fileName";
  return imagePath;
}
