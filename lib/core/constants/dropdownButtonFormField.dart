
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:flutter/material.dart';

class AppDropdownButtonFormField extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final Function(dynamic) onChanged;
  final dynamic value;
  final String label;

  const AppDropdownButtonFormField({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          DropdownButtonFormField(
            items: items,
            onChanged: onChanged,
            value: value,
            decoration: InputDecoration(
              focusColor: AppColors.primary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              hintText: "Selecciona una opción",
            ),
          ),
        ],
      ),
    );
  }
}