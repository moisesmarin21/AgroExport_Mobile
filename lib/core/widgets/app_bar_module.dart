import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBarModule extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  const CustomAppBarModule({
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
