import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/datePickerField.dart';
import 'package:consorcio_app/core/constants/dropdownButtonFormField.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/core/widgets/add_dialog_area.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/area_provider.dart';
import 'package:consorcio_app/providers/trabajador_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrabajadorForm extends StatefulWidget {
  final dynamic trabajador;
  final Function(Map<String, dynamic>) onSubmit;

  const TrabajadorForm({
    super.key,
    this.trabajador,
    required this.onSubmit,
  });

  @override
  State<TrabajadorForm> createState() => _TrabajadorFormState();
}

class _TrabajadorFormState extends State<TrabajadorForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nombresCtrl;
  late TextEditingController apellidosCtrl;
  late TextEditingController dniCtrl;
  late TextEditingController celularCtrl;
  late TextEditingController cargoCtrl;
  late TextEditingController condicionTrabajoCtrl;
  late TextEditingController direccionCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController fechaIngresoCtrl;
  late TextEditingController fechaNacimientoCtrl;
  late TextEditingController areaCtrl;
  late TextEditingController userNameCtrl;

  String? selectedArea;

  String formatFecha(String? fecha) {
    if (fecha == null || fecha.isEmpty) return '';

    try {
      final date = DateTime.parse(fecha);
      return "${date.year.toString().padLeft(4, '0')}-"
            "${date.month.toString().padLeft(2, '0')}-"
            "${date.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = Provider.of<AreaProvider>(context, listen: false);
      await provider.getAreas();
    });

    final t = widget.trabajador;

    nombresCtrl = TextEditingController(text: t?.nombres ?? '');
    apellidosCtrl = TextEditingController(text: t?.apellidos ?? '');
    dniCtrl = TextEditingController(text: t?.dni?.toString() ?? '');
    celularCtrl = TextEditingController(text: t?.celular?.toString() ?? '');
    cargoCtrl = TextEditingController(text: t?.cargo ?? '');
    condicionTrabajoCtrl = TextEditingController(text: t?.condicionTrabajo ?? '');
    direccionCtrl = TextEditingController(text: t?.direccion ?? '');
    emailCtrl = TextEditingController(text: t?.email ?? '');
    fechaIngresoCtrl = TextEditingController(text: formatFecha(t?.fechaIngreso));
    fechaNacimientoCtrl = TextEditingController(text: formatFecha(t?.fechaNacimiento));
    areaCtrl = TextEditingController(text: t?.areaNombre ?? '');
    userNameCtrl = TextEditingController(text: t?.userName ?? '');

    selectedArea = t?.areaNombre;
  }

  @override
  void dispose() {
    nombresCtrl.dispose();
    apellidosCtrl.dispose();
    dniCtrl.dispose();
    celularCtrl.dispose();
    cargoCtrl.dispose();
    condicionTrabajoCtrl.dispose();
    direccionCtrl.dispose();
    emailCtrl.dispose();
    fechaIngresoCtrl.dispose();
    fechaNacimientoCtrl.dispose();
    areaCtrl.dispose();
    userNameCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final areaId = Provider.of<AreaProvider>(context, listen: false)
        .areas
        .firstWhere((a) => a.nombre == selectedArea)
        .id;

    final data = {
      "id": widget.trabajador?.id,
      "nombres": nombresCtrl.text,
      "apellidos": apellidosCtrl.text,
      "dni": dniCtrl.text,
      "celular": celularCtrl.text,
      "cargo": cargoCtrl.text,
      "condicionTrabajo": condicionTrabajoCtrl.text,
      "direccion": direccionCtrl.text,
      "emailPersonal": emailCtrl.text,
      "fechaIngreso": fechaIngresoCtrl.text,
      "fechaNacimiento": fechaNacimientoCtrl.text,
      "areaId": areaId,
      "areaNombre": selectedArea,
      "userId": null,
      "userName": "",
      "activo": true,
    };

    try {
      final trabajadorProvider = Provider.of<TrabajadorProvider>(context, listen: false);

      if (widget.trabajador == null) {
        await trabajadorProvider.createTrabajador(data);
      } else {
        await trabajadorProvider.updateTrabajador(
          widget.trabajador.id,
          data,
        );
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.trabajador == null
                ? "Trabajador creado correctamente"
                : "Trabajador actualizado correctamente",
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
    final isEdit = widget.trabajador != null;
    final areas = Provider.of<AreaProvider>(context).areas
        .map((a) => a.nombre).toSet().toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? "Editar Trabajador" : "Nuevo Trabajador",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField("Nombres", nombresCtrl, required: true),
              _buildField("Apellidos", apellidosCtrl, required: true),
              _buildField("DNI", dniCtrl,
                  required: true, keyboard: TextInputType.number),
              _buildField("Celular", celularCtrl,
                  keyboard: TextInputType.number),
              _buildField("Cargo", cargoCtrl),
              _buildField("Condición de Trabajo", condicionTrabajoCtrl),
              _buildField("Dirección", direccionCtrl),
              _buildField("Email", emailCtrl,
                  keyboard: TextInputType.emailAddress),

              DatePickerField(
                label: "Fecha de Ingreso",
                controller: fechaIngresoCtrl,
                initialValue: DateTime.now(),
              ),

              const SizedBox(height: 12),

              DatePickerField(
                label: "Fecha de Nacimiento",
                controller: fechaNacimientoCtrl,
                initialValue: DateTime(2000, 1, 1),
              ),

              const SizedBox(height: 12),

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

              const SizedBox(height: 12),

              // _buildField("Nombre de Usuario", userNameCtrl),

              // const SizedBox(height: 12),

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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.textPrimary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary),
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