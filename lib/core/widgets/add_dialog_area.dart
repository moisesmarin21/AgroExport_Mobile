import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/providers/area_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<String?> showAddAreaDialog(BuildContext context) async {
  final areaNameCtrl = TextEditingController();
  final areaDescripcionCtrl = TextEditingController();

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Agregar Nueva Área"),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextField(
                controller: areaNameCtrl,
                decoration: const InputDecoration(
                  labelText: "Nombre del Área",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: areaDescripcionCtrl,
                decoration: const InputDecoration(
                  labelText: "Descripción del Área",
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
              final nombre = areaNameCtrl.text.trim();
              final descripcion = areaDescripcionCtrl.text.trim();

              if (nombre.isEmpty) return;

              final data = {
                "nombre": nombre,
                "descripcion": descripcion,
                "activo": true,
              };

              final areaProvider = Provider.of<AreaProvider>(context, listen: false);

              await areaProvider.createArea(data);
              await areaProvider.getAreas();

              Navigator.pop(context, nombre);
            },
            child: const Text("Agregar", style: AppStyles.buttonWhiteText),
          )
        ],
      );
    },
  );
}