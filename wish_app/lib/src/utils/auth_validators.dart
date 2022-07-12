import 'package:wish_app/src/utils/validators.dart' as validators;

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
    "Email",
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
  );
  if (baseCheck == null) {
    emailMessage ??= "Email is wrong.";

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
    "Password",
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
  int minLength = 5,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
  bool validateByRegExp = true,
  String? loginMessage,
}) {
  var baseCheck = validators.onlyNumbersAndLettersCheck(
    value,
    "Login",
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );
  return baseCheck;
}
