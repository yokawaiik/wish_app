import 'package:get/get.dart';

String? baseFieldCheck(
  String fieldName,
  String? value, {
  bool isRequired = false,
  String? emptyLengthMessage,
  int minLength = 10,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
}) {
  // minLengthMessage ??= "$fieldName must be more then $minLength.";
  // maxLengthMessage ??= "$fieldName must be less then $maxLength.";
  // emptyLengthMessage ??= "$fieldName is required.";
  minLengthMessage ??=
      "gm_u_base_field_check_default_min_length_message".trParams({
    "fieldName": fieldName,
    "minLength": minLength.toString(),
  });
  maxLengthMessage ??=
      "gm_u_base_field_check_default_max_length_message".trParams({
    "fieldName": fieldName,
    "maxLength": maxLength.toString(),
  });
  emptyLengthMessage ??=
      "gm_u_base_field_check_default_empty_length_message".trParams({
    "fieldName": fieldName,
  });

  if (isRequired) {
    if (value == null || value.isEmpty) {
      return emptyLengthMessage;
    } else if (value.length < minLength) {
      return minLengthMessage;
    } else if (value.length > maxLength) {
      return maxLengthMessage;
    }
  } else {
    if (value != null && value.length > maxLength) {
      return maxLengthMessage;
    }
  }

  return null;
}

String? onlyNumbersAndLettersCheck(
  String? value,
  String fieldName, {
  String? emptyLengthMessage,
  bool isRequired = false,
  int minLength = 10,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
  bool validateByRegExp = true,
  String? message,
}) {
  var baseCheck = baseFieldCheck(
    fieldName,
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );
  if (baseCheck == null) {
    // message ??= "'$fieldName' must contain only letters and numbers.";
    message ??= "gm_u_only_numbers_and_letters_check_message".trParams({
      "fieldName": fieldName,
    });

    if (validateByRegExp) {
      bool isValid = RegExp(r"[\w.-]{0,19}[0-9a-zA-Z]$").hasMatch(value!);
      if (!isValid) return message;
    }
  }
  return baseCheck;
}
