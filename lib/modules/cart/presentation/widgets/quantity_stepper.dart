import 'package:flutter/material.dart';
import 'package:mini_project_pwa/config/theme/app_colors.dart';

/// Use for call to action '-' or '+' for product cart quantity values
class QuantityStepper extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const QuantityStepper({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: BoxConstraints(
        maxHeight: 28,
        maxWidth: 28,
      ),
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryBlue),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
