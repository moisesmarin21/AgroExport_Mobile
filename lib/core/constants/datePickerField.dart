import 'package:consorcio_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialValue;

  const DatePickerField({
    super.key,
    required this.label,
    required this.controller,
    this.firstDate,
    this.lastDate,
    this.initialValue,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = initialValue ?? DateTime.now();

    if (controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('yyyy-MM-dd').parse(controller.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,       // Color del encabezado y botones "OK"
              onPrimary: Colors.white,    // Color del texto en el encabezado
              surface: Colors.white,      // Fondo del calendario
              onSurface: Colors.black,    // Color de los días
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // Color de botones Cancel/OK
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller.text.isEmpty && initialValue != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(initialValue!);
    }

    return TextFormField(
      cursorColor: AppColors.primary,
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      onTap: () => _selectDate(context),
    );
  }
}