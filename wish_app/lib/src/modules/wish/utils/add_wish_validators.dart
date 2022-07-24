import 'package:get/get.dart';

import '../../global/utils/validators.dart';

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
    'wish_utils_check_link_field_name'.tr,
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );
  if (baseCheck == null && isRequired) {
    linkMessage ??= "wish_utils_check_link_link_message".tr;

    if (validateByRegExp) {
      bool isLinkValid = Uri.tryParse(value!)?.hasAbsolutePath ?? false;
      if (!isLinkValid) return linkMessage;
    }
  }
  return baseCheck;
}
