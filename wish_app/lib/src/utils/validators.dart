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
  minLengthMessage ??= "$fieldName must be more then $minLength.";
  maxLengthMessage ??= "$fieldName must be less then $maxLength.";
  emptyLengthMessage ??= "$fieldName is required.";

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
    message ??= "'$fieldName' must contain only letters and numbers.";

    if (validateByRegExp) {
      bool isValid = RegExp(r"[\w.-]{0,19}[0-9a-zA-Z]$").hasMatch(value!);
      if (!isValid) return message;
    }
  }
  return baseCheck;
}
