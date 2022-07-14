String generateProfileImagePath({
  required String rawFilePath,
  required String id,
  String inFileName = 'avatar',
  String inFolderName = 'users/uuid',
}) {
  final fileExt = rawFilePath.split('.').last;
  final fileName = '${inFileName}.$fileExt'.replaceAll(" ", "");
  final imagePath = "$inFolderName/$fileName";
  return imagePath;
}
