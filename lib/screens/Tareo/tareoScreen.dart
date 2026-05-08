import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/core/widgets/tareo_form.dart';
import 'package:consorcio_app/providers/tareo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TareoScreen extends StatefulWidget {
  const TareoScreen({super.key});

  @override
  State<TareoScreen> createState() => _TareoScreenState();
}

class _TareoScreenState extends State<TareoScreen> {
  final ScrollController _scrollController = ScrollController();
  Future<void> _loadData() async {
    final provider = Provider.of<TareoProvider>(context, listen: false);
    await provider.getTareos();
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final provider = Provider.of<TareoProvider>(context, listen: false);

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        provider.loadMore();
      }
    });

    Future.microtask(() => _loadData());
  }

  // Abrir formulario para agregar o editar
  Future<void> _goToForm({dynamic tareo}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TareoForm(
          tareo: tareo,
          onSubmit: (data) {},
        ),
      ),
    );

    // 🔥 RECARGA AUTOMÁTICA
    await _loadData();
    setState(() {});
  }

  Future<DateTime?> _pickDate(DateTime initial) {
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }  

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TareoProvider>(context);
    final tareos = provider.tareos;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Tareos",
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add, color: AppColors.background),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              _buildHeaderFiltros(),
              Expanded(
                child: tareos.isEmpty
                    ? const Center(
                        child: Text(
                          "No hay tareos registrados",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: tareos.length + (provider.hasMore ? 1 : 0),
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            if (index == tareos.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                
                            final tareo = tareos[index];
                
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _showTareoDetailDialog(tareo),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tareo.detalles.first.trabajadorNombre,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Actividad: ${tareo.detalles.first.actividadNombre}",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Area: ${tareo.detalles.first.areaNombre}",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total: S/.${tareo.detalles.first.costoTotal.toString()}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: tareo.estado == "Pagado"
                                                ? Colors.green.withOpacity(0.15)
                                                : Colors.red.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            tareo.estado,
                                            style: TextStyle(
                                              color: tareo.estado == "Pagado"
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
    );
  }

  // Parametros
  Widget _buildHeaderFiltros() {
    final provider = Provider.of<TareoProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rango de fechas:",
            style: AppStyles.subtitleBlack,
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Expanded(
                child: _dateField(
                  label: "Fecha Inicio",
                  date: provider.fechaInicio,
                  onTap: (date) async {
                    final newDate = await _pickDate(date);
                    if (newDate != null) {
                      provider.aplicarFiltros(
                        fechaInicio: newDate,
                        fechaFin: provider.fechaFin,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dateField(
                  label: "Fecha Fin",
                  date: provider.fechaFin,
                  onTap: (date) async {
                    final newDate = await _pickDate(date);
                    if (newDate != null) {
                      provider.aplicarFiltros(
                        fechaInicio: provider.fechaInicio,
                        fechaFin: newDate,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: AppButtonStyles.primary,
                onPressed: () {
                  provider.aplicarFiltros(
                    fechaInicio: provider.fechaInicio,
                    fechaFin: provider.fechaFin,
                  );
                },
                child: Text("Aplicar", style: AppStyles.buttonWhiteText),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _dateField({required String label, required DateTime date, required Function(DateTime) onTap}) 
  {
    return InkWell(
      onTap: () => onTap(date),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "${date.toLocal()}".split(' ')[0],
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // Nuevo: dialogo flotante para ver detalle del tareo
  void _showTareoDetailDialog(dynamic tareo) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tareo del día: ${tareo.fecha.split("T").first}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Text("Supervisor: ${tareo.supervisorNombre}"),
              Text("Estado: ${tareo.estado}"),
              Text("Total Costo: S/.${tareo.totalCosto.toStringAsFixed(2)}"),
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tareo.detalles.length,
                itemBuilder: (context, index) {
                  final d = tareo.detalles[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.trabajadorNombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text("Área: ${d.areaNombre}"),
                        Text("Actividad: ${d.actividadNombre}"),
                        Text("Tipo Sueldo: ${d.tipoSueldoNombre}"),
                        const SizedBox(height: 4),
                        Text(
                            "Horas: ${d.horaInicio} - ${d.horaFin} (Refrigerio: ${d.horaInicioRefrigerio} - ${d.horaFinRefrigerio})"),
                        Text("Cantidad Horas: ${d.cantidadHoras}"),
                        Text("Tarifa: S/.${d.tarifa}"),
                        Text("Rendimiento Destajo: ${d.rendimientoDestajo}"),
                        Text("Costo Pasaje: S/.${d.costoPasaje}"),
                        Text("Costo Almuerzo: S/.${d.costoAlmuerzo}"),
                        Text("Costo Total: S/.${d.costoTotal}"),
                        if (d.observacion.isNotEmpty)
                          Text("Observaciones: ${d.observacion}"),
                      ],
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cerrar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
