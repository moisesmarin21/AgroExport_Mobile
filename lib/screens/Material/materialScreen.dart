import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/core/widgets/material_form.dart';
import 'package:consorcio_app/providers/material_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialScreen extends StatefulWidget {
  const MaterialScreen({super.key});

  @override
  State<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  Future<void> _loadData() async {
    final provider = Provider.of<MaterialProvider>(context, listen: false);
    await provider.getMateriales();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _goToForm({dynamic material}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MaterialForm(
          material: material,
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
    final provider = Provider.of<MaterialProvider>(context);
    final materiales = provider.materiales;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Materiales",
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add, color: AppColors.background),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : materiales.isEmpty
              ? const Center(
                  child: Text(
                    "No hay materiales registrados",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: materiales.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final material = materiales[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _goToForm(material: material),
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
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                material.nombre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Area: ${material.areaNombre}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Descripción: ${material.descripcion}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                material.unidadMedida,
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
                                    "Stock: ${material.stock}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4),
                                    decoration: BoxDecoration(
                                      color: material.activo == true
                                          ? Colors.green
                                              .withOpacity(0.15)
                                          : Colors.red
                                              .withOpacity(0.15),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      material.activo == true
                                          ? "Activo"
                                          : "Inactivo",
                                      style: TextStyle(
                                        color:
                                            material.activo == true
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