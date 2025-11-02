import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.titleText,
    this.actions = const [],
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80.0,
      title: Row(
        children: [
          Image.asset('assets/images/Logo_campestre.jpg', height: 60),
          const SizedBox(width: 12),
          Text(titleText),
        ],
      ),
      actions: [
        ...actions,
        const SizedBox(width: 10),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      80.0 + (bottom?.preferredSize.height ?? 0.0));
}