import 'package:flutter/material.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final BorderRadius borderRadius;

  const RoundedAppBar({super.key, required this.appBar, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: appBar,
    );
  }

  @override
  Size get preferredSize => appBar.preferredSize;
}
