import 'package:flutter/material.dart';

import 'default_text_field.dart';

class PasswordTextField extends StatefulWidget {
  String? labelText;
  String? initialValue;
  Function(String)? onChanged;

  int? minLines;
  int? maxLines;
  int? maxLength;
  Widget? suffixIcon;

  TextInputType? keyboardType;

  TextEditingController? controller;

  Icon? prefixIcon;

  String? Function(String?)? validator;

  Iterable<String>? autofillHints;

  PasswordTextField({
    this.controller,
    this.initialValue,
    required this.onChanged,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    Key? key,
    this.autofillHints,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextField();
}

class _PasswordTextField extends State<PasswordTextField> {
  late bool _isPasswordShow;

  @override
  void initState() {
    _isPasswordShow = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      obscureText: !_isPasswordShow,
      autofillHints: widget.autofillHints,
      controller: widget.controller,
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.text,
      validator: widget.validator,
      maxLength: widget.maxLength,
      labelText: widget.labelText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _isPasswordShow = !_isPasswordShow;
          });
        },
        icon: Icon(
          _isPasswordShow ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
