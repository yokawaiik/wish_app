String generateProfileImagePath({
  required String rawFilePath,
  required String id,
  String folderName = 'users',
}) {
  final fileExt = rawFilePath.split('.').last;
  final fileName = '${id}.$fileExt'.replaceAll(" ", "");
  final imagePath = "$folderName/$fileName";
  return imagePath;
}
