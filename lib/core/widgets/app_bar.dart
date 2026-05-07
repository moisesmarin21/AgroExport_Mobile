import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 30,
              ),
              onPressed: onBack ??
                  () {
                    Navigator.pop(context);
                  },
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: AppStyles.titleWhite,
            ),
          ],
        ),
        actions: actions,
      ),
    );
  }
}
