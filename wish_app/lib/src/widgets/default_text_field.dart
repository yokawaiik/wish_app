import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultTextField extends StatelessWidget {
  String? labelText;
  String? initialValue;
  Function(String)? onChanged;

  bool isPassword;
  int? minLines;
  int? maxLines;
  int? maxLength;


  Icon? prefixIcon;

  String? Function(String?)? validator;

  DefaultTextField({
    this.initialValue,
    required this.onChanged,
    this.labelText,
    this.isPassword = false,
    this.prefixIcon,
    this.validator,
    this.minLines,
    this.maxLines,
    this.maxLength,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      obscureText: isPassword ? true : false,
      validator: validator,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
