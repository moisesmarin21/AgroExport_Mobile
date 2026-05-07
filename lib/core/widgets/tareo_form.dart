 import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/dropdownButtonFormField.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/actividad_provider.dart';
import 'package:consorcio_app/providers/area_provider.dart';
import 'package:consorcio_app/providers/auth_provider.dart';
import 'package:consorcio_app/providers/tareo_provider.dart';
import 'package:consorcio_app/providers/tipoSueldo_provider.dart';
import 'package:consorcio_app/providers/trabajador_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TareoForm extends StatefulWidget {
  final dynamic tareo;
  final Function(Map<String, dynamic>) onSubmit;

  const TareoForm({
    super.key,
    this.tareo,
    required this.onSubmit,
  });

  @override
  State<TareoForm> createState() => _TareoFormState();
}

class _TareoFormState extends State<TareoForm> {
  final _formKey = GlobalKey<FormState>();

  /// CONTROLLERS
  late TextEditingController horasCtrl;
  late TextEditingController tarifaCtrl;
  late TextEditingController destajoCtrl;
  late TextEditingController pasajeCtrl;
  late TextEditingController almuerzoCtrl;
  late TextEditingController obsCtrl;

  String estado = "Aprobado";

  String trabajador = "";
  String area = "";
  String actividad = "";
  String tipoSueldo = "";

  /// HORAS
  String horaInicio = "08:00";
  String horaFin = "17:00";
  String refInicio = "12:00";
  String refFin = "13:00";

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await Provider.of<ActividadProvider>(context, listen: false).getActividades();
      await Provider.of<AreaProvider>(context, listen: false).getAreas();
      await Provider.of<TrabajadorProvider>(context, listen: false).getTrabajadores();
      await Provider.of<TipoSueldoProvider>(context, listen: false).getTiposSueldo();
    });

    final d = widget.tareo?.detalles?.isNotEmpty == true
        ? widget.tareo.detalles.first
        : null;

    trabajador = d?.trabajadorNombre ?? "";
    area = d?.areaNombre ?? "";
    actividad = d?.actividadNombre ?? "";
    tipoSueldo = d?.tipoSueldoNombre ?? "";

    horaInicio = d?.horaInicio ?? "08:00";
    horaFin = d?.horaFin ?? "17:00";
    refInicio = d?.refrigerioInicio ?? "12:00";
    refFin = d?.refrigerioFin ?? "13:00";

    horasCtrl = TextEditingController();
    tarifaCtrl = TextEditingController(text: d?.tarifa?.toString() ?? "0");
    destajoCtrl = TextEditingController(text: d?.rendimientoDestajo?.toString() ?? "0");
    pasajeCtrl = TextEditingController(text: d?.costoPasaje?.toString() ?? "0");
    almuerzoCtrl = TextEditingController(text: d?.costoAlmuerzo?.toString() ?? "0");
    obsCtrl = TextEditingController(text: d?.observacion ?? "");

    _recalcularHoras();
  }

  @override
  void dispose() {
    horasCtrl.dispose();
    tarifaCtrl.dispose();
    destajoCtrl.dispose();
    pasajeCtrl.dispose();
    almuerzoCtrl.dispose();
    obsCtrl.dispose();
    super.dispose();
  }

  /// TIME PICKER
  Future<void> _pickTime(Function(String) setter, String current) async {
    final parts = current.split(":");

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

      setState(() {
        setter(formatted);
        _recalcularHoras();
      });
    }
  }

  double _toDouble(String h) {
    final p = h.split(":");
    return int.parse(p[0]) + int.parse(p[1]) / 60;
  }

  void _recalcularHoras() {
    double total =
        (_toDouble(horaFin) - _toDouble(horaInicio)) -
        (_toDouble(refFin) - _toDouble(refInicio));

    horasCtrl.text = total.toStringAsFixed(2);
  }

  double _total() {
    double horas = double.tryParse(horasCtrl.text) ?? 0;
    double tarifa = double.tryParse(tarifaCtrl.text) ?? 0;
    double pasaje = double.tryParse(pasajeCtrl.text) ?? 0;
    double almuerzo = double.tryParse(almuerzoCtrl.text) ?? 0;

    return (horas * tarifa) + pasaje + almuerzo;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();

    final trabajadorProvider = Provider.of<TrabajadorProvider>(context, listen: false);
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final actividadProvider = Provider.of<ActividadProvider>(context, listen: false);
    final tipoProvider = Provider.of<TipoSueldoProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.session?.user;

    // 🔍 Obtener IDs desde nombres
    final trabajadorObj = trabajadorProvider.trabajadores.firstWhere((t) => "${t.nombres} ${t.apellidos}" == trabajador);
    final areaObj = areaProvider.areas.firstWhere((a) => a.nombre == area);
    final actividadObj = actividadProvider.actividades.firstWhere((a) => a.nombre == actividad);
    final tipoObj = tipoProvider.tiposSueldo.firstWhere((t) => t.nombre == tipoSueldo);

    final data = {
      "id": widget.tareo?.id ?? 0,
      "fecha": now.toIso8601String(),
      "supervisorId": user?.id,
      "supervisorNombre": user?.usuario,
      "estado": "Pendiente",
      "totalCosto": _total(),
      "dia": now.day,
      "mes": now.month,
      "anio": now.year,
      "detalles": [
        {
          "id": null,
          "tareoId": widget.tareo?.id ?? 0,
          "trabajadorId": trabajadorObj.id,
          "trabajadorNombre": trabajador,
          "areaId": areaObj.id,
          "areaNombre": area,
          "actividadId": actividadObj.id,
          "actividadNombre": actividad,
          "tipoSueldoId": tipoObj.id,
          "tipoSueldoNombre": tipoSueldo,
          "horaInicio": horaInicio,
          "horaFin": horaFin,
          "horaInicioRefrigerio": refInicio,
          "horaFinRefrigerio": refFin,
          "cantidadHoras": double.tryParse(horasCtrl.text) ?? 0,
          "rendimientoDestajo": double.tryParse(destajoCtrl.text) ?? 0,
          "costoPasaje": double.tryParse(pasajeCtrl.text) ?? 0,
          "costoAlmuerzo": double.tryParse(almuerzoCtrl.text) ?? 0,
          "tarifa": double.tryParse(tarifaCtrl.text) ?? 0,
          "costoTotal": _total(),
          "observaciones": obsCtrl.text.isEmpty
              ? ""
              : obsCtrl.text,
        }
      ]
    };

    final provider = Provider.of<TareoProvider>(context, listen: false);

    try {
      if (widget.tareo == null) {
        await provider.createTareo(data);
      } else {
        await provider.updateTareo(widget.tareo.id, data);
      }

      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  /// UI HELPERS
  Widget _field(String label, TextEditingController ctrl,
      {bool required = false, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: type,
        cursorColor: AppColors.primary,
        decoration: _dec(label),
        validator: (v) {
          if (required && (v == null || v.isEmpty)) return "Campo obligatorio";
          return null;
        },
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _time(String label, String value, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.textPrimary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tareo != null;

    final actividades = context.watch<ActividadProvider>().actividades;
    final trabajadores = context.watch<TrabajadorProvider>().trabajadores;
    final areas = context.watch<AreaProvider>().areas;
    final tipos = context.watch<TipoSueldoProvider>().tiposSueldo;

    return Scaffold(
      appBar: CustomAppBar(
        title: isEdit ? "Editar Tareo" : "Nuevo Tareo",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppDropdownButtonFormField(
                label: "Trabajador",
                value: trabajador.isEmpty ? null : trabajador,
                items: trabajadores
                    .map((t) => DropdownMenuItem(
                          value: "${t.nombres} ${t.apellidos}",
                          child: Text("${t.nombres} ${t.apellidos}"),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => trabajador = v),
              ),

              AppDropdownButtonFormField(
                label: "Area",
                value: area.isEmpty ? null : area,
                items: areas
                    .map((a) => DropdownMenuItem(
                          value: a.nombre,
                          child: Text(a.nombre),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => area = v),
              ),

              AppDropdownButtonFormField(
                label: "Actividad",
                value: actividad.isEmpty ? null : actividad,
                items: actividades
                    .map((a) => DropdownMenuItem(
                          value: a.nombre,
                          child: Text(a.nombre),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => actividad = v),
              ),

              AppDropdownButtonFormField(
                label: "Tipo sueldo",
                value: tipoSueldo.isEmpty ? null : tipoSueldo,
                items: tipos
                    .map((t) => DropdownMenuItem(
                          value: t.nombre,
                          child: Text(t.nombre),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => tipoSueldo = v),
              ),

              _time("Hora Inicio", horaInicio,
                  () => _pickTime((v) => horaInicio = v, horaInicio)),
              _time("Hora Fin", horaFin,
                  () => _pickTime((v) => horaFin = v, horaFin)),
              _time("Refrigerio Inicio", refInicio,
                  () => _pickTime((v) => refInicio = v, refInicio)),
              _time("Refrigerio Fin", refFin,
                  () => _pickTime((v) => refFin = v, refFin)),

              _field("Horas", horasCtrl, type: TextInputType.number),
              _field("Tarifa (S/.) *", tarifaCtrl,
                  required: true, type: TextInputType.number),
              _field("Rendimiento Destajo", destajoCtrl,
                  type: TextInputType.number),
              _field("Pasaje", pasajeCtrl, type: TextInputType.number),
              _field("Almuerzo", almuerzoCtrl, type: TextInputType.number),
              _field("Observaciones", obsCtrl),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "TOTAL: ${_total().toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

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
}