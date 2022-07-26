import 'package:get/get.dart';

import 'validators.dart' as validators;

String? checkEmail(
  String? value, {
  String? emptyLengthMessage,
  int minLength = 10,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
  bool validateByRegExp = true,
  String? emailMessage,
}) {
  var baseCheck = validators.baseFieldCheck(
    "gm_u_check_email_field_name".tr,
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
  );
  if (baseCheck == null) {
    emailMessage ??= "gm_u_check_email_email_message".tr;

    if (validateByRegExp) {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value!);
      if (!emailValid) return emailMessage;
    }
  }
  return baseCheck;
}

String? checkPassword(
  String? value, {
  String? emptyLengthMessage,
  bool isRequired = true,
  int minLength = 5,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
}) {
  var baseCheck = validators.baseFieldCheck(
    "gm_u_check_password_field_name".tr,
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );

  return baseCheck;
}

String? checkLogin(
  String? value, {
  bool isRequired = true,
  String? emptyLengthMessage,
  int minLength = 4,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
  bool validateByRegExp = true,
  String? loginMessage,
}) {
  var baseCheck = validators.onlyNumbersAndLettersCheck(
    value,
    "gm_u_check_login_field_name".tr,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );
  return baseCheck;
}
