import '../../global/utils/validators.dart' as validators;

String? checkPassword(
  String? value, {
  String fieldName = "New Password",
  String? emptyLengthMessage,
  bool isRequired = true,
  int minLength = 5,
  String? minLengthMessage,
  int maxLength = 100,
  String? maxLengthMessage,
  bool isRetypePassword = false,
  String? originalField,
}) {
  var baseCheck = validators.baseFieldCheck(
    fieldName,
    value,
    minLength: minLength,
    emptyLengthMessage: emptyLengthMessage,
    maxLength: maxLength,
    maxLengthMessage: maxLengthMessage,
    isRequired: isRequired,
  );

  if (baseCheck != null) return baseCheck;

  if (isRetypePassword && (value != originalField)) {
    return 'These fields is not equal.';
  }
  return null;
}
