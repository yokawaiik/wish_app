import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextFieldLogin extends StatelessWidget {
  String? labelText;
  String? initialValue;
  Function(String)? onChanged;

  bool isPassword;

  Icon? prefixIcon;

  String? Function(String?)? validator;

  TextFieldLogin({
    this.initialValue,
    required this.onChanged,
    this.labelText,
    this.isPassword = false,
    this.prefixIcon,
    this.validator,
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
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
