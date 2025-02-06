import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? Function(String?)? validator;
  final Color? primaryColor;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;

  const PasswordField({
    Key? key,
    required this.controller,
    this.hintText = 'كلمة المرور',
    this.labelText,
    this.validator,
    this.primaryColor = Colors.blue,
    this.contentPadding = const EdgeInsets.all(20),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: widget.borderRadius,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        validator: widget.validator,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          prefixIcon: Icon(Icons.lock_outline, color: widget.primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: widget.primaryColor,
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ),
          border: InputBorder.none,
          contentPadding: widget.contentPadding,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}