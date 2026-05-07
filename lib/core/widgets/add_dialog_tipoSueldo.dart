import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/dropdownButtonFormField.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/providers/tipoSueldo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<String?> showAddTipoSueldoDialog(BuildContext context) async {
  final tipoSueldoNameCtrl = TextEditingController();
  final tipoSueldoDescripcionCtrl = TextEditingController();
  final unidadMedidaCtrl = TextEditingController();
  Map<String, String> unidadesMedida = {
    "Día": "Día (Jornal)",
    "Hora": "Hora",
    "Kilo": "Kilo (Cosecha)",
    "Jaba": "Jaba",
    "Mes": "Mes (Fijo)",
    "Otra": "Otra",
  };

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Agregar Nuevo Tipo de Sueldo"),
        content: SizedBox(
          height: 280,
          child: Column(
            children: [
              TextField(
                controller: tipoSueldoNameCtrl,
                decoration: const InputDecoration(
                  labelText: "Nombre del Tipo de Sueldo",
                ),
              ),
              const SizedBox(height: 15),
              AppDropdownButtonFormField(
                label: "Unidad de medida",
                value: unidadMedidaCtrl.text.isEmpty ? null : unidadMedidaCtrl.text,
                items: unidadesMedida.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  //POR COMPROBAR SI GUARDA SIN SETSTATE
                  unidadMedidaCtrl.text = value ?? '';
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: tipoSueldoDescripcionCtrl,
                decoration: const InputDecoration(
                  labelText: "Descripción del Tipo de Sueldo",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: AppStyles.buttonText),
          ),
          ElevatedButton(
            style: AppButtonStyles.primary,
            onPressed: () async {
              final nombre = tipoSueldoNameCtrl.text.trim();
              final descripcion = tipoSueldoDescripcionCtrl.text.trim();

              if (nombre.isEmpty) return;

              final data = {
                "nombre": nombre,
                "unidadMedida": "Soles",
                "descripcion": descripcion,
                "activo": true,
              };

              final tipoSueldoProvider = Provider.of<TipoSueldoProvider>(context, listen: false);

              await tipoSueldoProvider.createTipoSueldo(data);
              await tipoSueldoProvider.getTiposSueldo();

              Navigator.pop(context, nombre);
            },
            child: const Text("Agregar", style: AppStyles.buttonWhiteText),
          )
        ],
      );
    },
  );
}