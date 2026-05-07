import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/proveedor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProveedorForm extends StatefulWidget {
  final dynamic proveedor; // puedes tiparlo como Proveedor si ya lo tienes
  final Function(Map<String, dynamic>) onSubmit;

  const ProveedorForm({
    super.key,
    this.proveedor,
    required this.onSubmit,
  });

  @override
  State<ProveedorForm> createState() => _ProveedorFormState();
}

class _ProveedorFormState extends State<ProveedorForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController responsableCtrl;
  late TextEditingController rucCtrl;
  late TextEditingController cuentaCtrl;
  late TextEditingController razonSocialCtrl;
  late TextEditingController bancoCtrl;
  late TextEditingController ggnglnCtrl;
  late TextEditingController clpCtrl;

  String estado = "Activo";

  @override
  void initState() {
    super.initState();

    final p = widget.proveedor;

    responsableCtrl = TextEditingController(text: p?.responsable ?? '');
    rucCtrl = TextEditingController(text: p?.ruc ?? '');
    cuentaCtrl = TextEditingController(text: p?.nroCuenta ?? '');
    razonSocialCtrl = TextEditingController(text: p?.razonSocial ?? '');
    bancoCtrl = TextEditingController(text: p?.banco ?? '');
    ggnglnCtrl = TextEditingController(text: p?.ggngln ?? '');
    clpCtrl = TextEditingController(text: p?.clp ?? '');

    estado = p?.estado ?? "Activo";
  }

  @override
  void dispose() {
    responsableCtrl.dispose();
    rucCtrl.dispose();
    cuentaCtrl.dispose();
    razonSocialCtrl.dispose();
    bancoCtrl.dispose();
    ggnglnCtrl.dispose();
    clpCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "id": widget.proveedor?.id,
      "responsable": responsableCtrl.text,
      "ruc": rucCtrl.text,
      "nroCuenta": cuentaCtrl.text,
      "razonSocial": razonSocialCtrl.text,
      "banco": bancoCtrl.text,
      "ggngln": ggnglnCtrl.text,
      "clp": clpCtrl.text,
      "estado": estado,
    };

    try {
      final proveedorProvider = Provider.of<ProveedorProvider>(context, listen: false);

      if (widget.proveedor == null) {
        /// ➕ CREAR
        await proveedorProvider.createProveedor(data);
      } else {
        /// ✏️ EDITAR
        await proveedorProvider.updateProveedor(
          widget.proveedor.id,
          data,
        );
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.proveedor == null
                ? "Proveedor creado correctamente"
                : "Proveedor actualizado correctamente",
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
    final isEdit = widget.proveedor != null;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? "Editar Proveedor" : "Nuevo Proveedor",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _buildField("Razón Social", razonSocialCtrl, required: true),
              _buildField("Responsable", responsableCtrl, required: true),
              _buildField("RUC", rucCtrl, keyboard: TextInputType.number),
              _buildField("Nro Cuenta", cuentaCtrl, keyboard: TextInputType.number),
              _buildField("Banco", bancoCtrl),
              _buildField("GGNGLN", ggnglnCtrl),
              _buildField("CLP", clpCtrl),

              // const SizedBox(height: 12),

              // /// 🔹 ESTADO
              // DropdownButtonFormField<String>(
              //   value: estado,
              //   decoration: _inputDecoration("Estado"),
              //   items: ["Activo", "Inactivo"]
              //       .map((e) => DropdownMenuItem(
              //             value: e,
              //             child: Text(e),
              //           ))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() => estado = value!);
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