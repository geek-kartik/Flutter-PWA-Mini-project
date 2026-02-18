import 'package:flutter/material.dart';
import 'package:mini_project_pwa/config/theme/app_colors.dart';

/// Use this common app bar across the app
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
      title: Text(title),
      centerTitle: centerTitle,
      actions: actions,
      leading: SizedBox.shrink(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
