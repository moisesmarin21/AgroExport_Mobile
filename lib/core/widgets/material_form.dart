import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/dropdownButtonFormField.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/core/widgets/add_dialog_area.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/area_provider.dart';
import 'package:consorcio_app/providers/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialForm extends StatefulWidget {
  final dynamic material; // puedes tiparlo como Material si ya lo tienes
  final Function(Map<String, dynamic>) onSubmit;

  const MaterialForm({
    super.key,
    this.material,
    required this.onSubmit,
  });

  @override
  State<MaterialForm> createState() => _MaterialFormState();
}

class _MaterialFormState extends State<MaterialForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombreCtrl;
  late TextEditingController descripcionCtrl;
  late TextEditingController areaCtrl;
  late TextEditingController unidadMedidaCtrl;
  late TextEditingController stockCtrl;

  bool activo = true;
  String? selectedArea;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final areaProvider = Provider.of<AreaProvider>(context, listen: false);
      await areaProvider.getAreas();
    });

    final p = widget.material;

    nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    descripcionCtrl = TextEditingController(text: p?.descripcion ?? '');
    areaCtrl = TextEditingController(text: p?.areaNombre ?? '');
    unidadMedidaCtrl = TextEditingController(text: p?.unidadMedida ?? '');
    stockCtrl = TextEditingController(text: p?.stock.toString() ?? '');

    activo = p?.activo ?? true;

    selectedArea = p?.areaNombre;
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    areaCtrl.dispose();
    unidadMedidaCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final areaId = Provider.of<AreaProvider>(context, listen: false)
        .areas
        .firstWhere((a) => a.nombre == selectedArea)
        .id;
    final data = {
      "id": widget.material?.id,
      "nombre": nombreCtrl.text,
      "descripcion": descripcionCtrl.text,
      "areaId": areaId,
      "areaNombre": selectedArea,
      "unidadMedida": unidadMedidaCtrl.text,
      "stock": stockCtrl.text,
      "activo": activo,
    };

    try {
      final materialProvider = Provider.of<MaterialProvider>(context, listen: false);

      if (widget.material == null) {
        /// ➕ CREAR
        await materialProvider.createMaterial(data);
      } else {
        /// ✏️ EDITAR
        await materialProvider.updateMaterial(
          widget.material.id,
          data,
        );
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.material == null
                ? "Material creado correctamente"
                : "Material actualizado correctamente",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final areas = Provider.of<AreaProvider>(context).areas
        .map((a) => a.nombre).toSet().toList();

    final Map<String, String> unidadesMedida = {
      "Kg": "Kilogramos (Kg)",
      "Lt": "Litros (Lt)",
      "Unidades": "Unidades / Piezas",
      "Sacos": "Sacos",
    };

    final isEdit = widget.material != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? "Editar Material" : "Nuevo Material",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildField("Nombre", nombreCtrl, required: true),
              _buildField("Descripción", descripcionCtrl, required: false),
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: AppDropdownButtonFormField(
                      label: "Área",
                      value: selectedArea,
                      items: [areas]
                          .expand((list) => list)
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedArea = value;
                          areaCtrl.text = value ?? '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final nuevaArea = await showAddAreaDialog(context);

                        if (nuevaArea != null) {
                          setState(() {
                            selectedArea = nuevaArea;
                            areaCtrl.text = nuevaArea;
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
              
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
                  setState(() {
                    unidadMedidaCtrl.text = value ?? '';
                  });
                },
              ),
              
              _buildField("Stock", stockCtrl, keyboard: TextInputType.number),

              // const SizedBox(height: 12),

              // /// 🔹 ESTADO
              // DropdownButtonFormField<bool>(
              //   value: activo,
              //   decoration: _inputDecoration("Activo"),
              //   items: [true, false]
              //       .map((e) => DropdownMenuItem(
              //             value: e,
              //             child: Text(e ? "Activo" : "Inactivo"),
              //           ))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() => activo = value!);
              //   },
              // ),

              const SizedBox(height: 20),

              /// 🔘 BOTÓN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: AppButtonStyles.primary,
                  child: Text(
                    isEdit ? "Actualizar" : "Guardar",
                    style: AppStyles.buttonWhiteText,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 INPUT REUTILIZABLE
  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        cursorColor: AppColors.primary,
        controller: controller,
        keyboardType: keyboard,
        decoration: _inputDecoration(label),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return "Campo obligatorio";
          }
          return null;
        },
      ),
    );
  }

  /// 🎨 ESTILO CONSISTENTE
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.textPrimary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}