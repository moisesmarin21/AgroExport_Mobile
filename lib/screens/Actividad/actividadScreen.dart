import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/widgets/actividad_form.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/actividad_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActividadScreen extends StatefulWidget {
  const ActividadScreen({super.key});

  @override
  State<ActividadScreen> createState() => _ActividadScreenState();
}

class _ActividadScreenState extends State<ActividadScreen> {
  Future<void> _loadData() async {
    final provider = Provider.of<ActividadProvider>(context, listen: false);
    await provider.getActividades();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _goToForm({dynamic actividad}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActividadForm(
          actividad: actividad,
          onSubmit: (data) {},
        ),
      ),
    );

    // 🔥 RECARGA AUTOMÁTICA
    await _loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActividadProvider>(context);
    final actividades = provider.actividades;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Actividades",
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add, color: AppColors.background),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : actividades.isEmpty
              ? const Center(
                  child: Text(
                    "No hay actividades registradas",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: actividades.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final actividad = actividades[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () =>
                            _goToForm(actividad: actividad),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                                "Nombre: ${actividad.nombre}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Descripcion: ${actividad.descripcion}",
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
                                    actividad.areaNombre,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          actividad.activo == true
                                              ? Colors.green
                                                  .withOpacity(
                                                      0.15)
                                              : Colors.red
                                                  .withOpacity(
                                                      0.15),
                                      borderRadius:
                                          BorderRadius.circular(
                                              20),
                                    ),
                                    child: Text(
                                      actividad.activo == true
                                          ? "Activo"
                                          : "Inactivo",
                                      style: TextStyle(
                                        color: actividad
                                                    .activo ==
                                                true
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight:
                                            FontWeight.w600,
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
    );
  }
}