import 'package:flutter/material.dart';

class SimpleAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const SimpleAppBarWidget({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
