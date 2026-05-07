import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/dropdownButtonFormField.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/actividad_provider.dart';
import 'package:consorcio_app/providers/area_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActividadForm extends StatefulWidget {
  final dynamic actividad; // puedes tiparlo como Actividad si ya lo tienes
  final Function(Map<String, dynamic>) onSubmit;

  const ActividadForm({
    super.key,
    this.actividad,
    required this.onSubmit,
  });

  @override
  State<ActividadForm> createState() => _ActividadFormState();
}

class _ActividadFormState extends State<ActividadForm> {
  final _formKey = GlobalKey<FormState>();

  String? selectedArea;

  late TextEditingController nombreCtrl;
  late TextEditingController descripcionCtrl;
  late TextEditingController areaCtrl;

  bool activo = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async{
      final areaProvider = Provider.of<AreaProvider>(context, listen: false);
      await areaProvider.getAreas();
    });

    final a = widget.actividad;

    nombreCtrl = TextEditingController(text: a?.nombre ?? '');
    descripcionCtrl = TextEditingController(text: a?.descripcion ?? '');
    areaCtrl = TextEditingController(text: a?.areaNombre ?? '');

    activo = a?.activo ?? true;
    selectedArea = a?.areaNombre;
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    areaCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final areaId = Provider.of<AreaProvider>(context, listen: false)
        .areas
        .firstWhere((a) => a.nombre == selectedArea)
        .id;
        

    final data = {
      "id": widget.actividad?.id,
      "nombre": nombreCtrl.text,
      "descripcion": descripcionCtrl.text,
      "areaId": areaId,
      "areaNombre": selectedArea,
      "activo": activo,
    };

    try {
      final actividadProvider =
          Provider.of<ActividadProvider>(context, listen: false);

      if (widget.actividad == null) {
        /// ➕ CREAR
        await actividadProvider.createActividad(data);
      } else {
        /// ✏️ EDITAR
        await actividadProvider.updateActividad(
          widget.actividad.id,
          data,
        );
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.actividad == null
                ? "Actividad creada correctamente"
                : "Actividad actualizada correctamente",
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
    final isEdit = widget.actividad != null;
    final areas = Provider.of<AreaProvider>(context)
        .areas
        .map((a) => a.nombre)
        .toSet()
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? "Editar Actividad" : "Nueva Actividad",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildField("Nombre", nombreCtrl, required: true),
              _buildField("Descripción", descripcionCtrl, required: false),
              
              AppDropdownButtonFormField(
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

              const SizedBox(height: 12),

              // ESTADO
              // AppDropdownButtonFormField(
              //   label: "Estado",
              //   value: activo,
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

              // const SizedBox(height: 20),

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