import '../../../utils/validators.dart';

String? checkLink(
  String? value, {
  String? emptyLengthMessage,
  bool isRequired = false,
  int minLength = 10,
  String? minLengthMessage,
  int maxLength = 500,
  String? maxLengthMessage,
  bool validateByRegExp = true,
  String? linkMessage,
}) {
  var baseCheck = baseFieldCheck(
    "Link",
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );
  if (baseCheck == null && isRequired) {
    linkMessage ??= "Link is wrong.";

    if (validateByRegExp) {
      bool isLinkValid = Uri.tryParse(value!)?.hasAbsolutePath ?? false;
      if (!isLinkValid) return linkMessage;
    }
  }
  return baseCheck;
}
