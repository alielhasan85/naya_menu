import 'package:flutter/material.dart';
import 'package:naya_menu/theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final double elevation;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.elevation = 0.0,
    this.backgroundColor,
    this.bottom,
    this.leading,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          title,
          style: AppTheme.appBarTheme.titleTextStyle,
        ),
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation,
      backgroundColor: backgroundColor ?? AppTheme.appBarTheme.backgroundColor,
      actions: actions,
      bottom: bottom,
      leading: leading,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
