import 'package:flutter/material.dart';
import 'package:mini_project_pwa/config/theme/app_colors.dart';

/// Reusable password text field widget with show/hide functionality.
///
/// Features:
/// - Toggle password visibility
/// - Validation support
/// - Customizable label and hint
/// - Accessibility support
class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final bool autofocus;

  const PasswordField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.hintText,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.autofocus = false,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !_obscureText,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      cursorColor: AppColors.primaryBlue,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        filled: true,
        prefixIcon: const Icon(Icons.password_outlined),
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryBlue),
        ),
        focusColor: AppColors.primaryBlue,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryBlue),
        ),
        suffixIcon: IconButton(
          key: const Key('password_visibility_toggle'),
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'Show password' : 'Hide password',
          ),
          onPressed: _togglePasswordVisibility,
        ),
      ),
      validator: widget.validator,
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
