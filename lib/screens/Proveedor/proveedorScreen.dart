import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/core/widgets/proveedor_form.dart';
import 'package:consorcio_app/providers/proveedor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Proveedorscreen extends StatefulWidget {
  const Proveedorscreen({super.key});

  @override
  State<Proveedorscreen> createState() => _ProveedorscreenState();
}

class _ProveedorscreenState extends State<Proveedorscreen> {
  Future<void> _loadData() async {
    final provider = Provider.of<ProveedorProvider>(context, listen: false);
    await provider.getProveedores();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _goToForm({dynamic proveedor}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProveedorForm(
          proveedor: proveedor,
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
    final provider = Provider.of<ProveedorProvider>(context);
    final proveedores = provider.proveedores;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Proveedores",
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _goToForm(),
        child: const Icon(Icons.add, color: AppColors.background),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : proveedores.isEmpty
              ? const Center(
                  child: Text(
                    "No hay proveedores registrados",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: proveedores.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final proveedor = proveedores[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () =>
                            _goToForm(proveedor: proveedor),
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
                              Text(
                                proveedor.razonSocial,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Responsable: ${proveedor.responsable}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "RUC: ${proveedor.ruc}",
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
                                    proveedor.banco,
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
                                          proveedor.estado ==
                                                  "Activo"
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
                                      proveedor.estado,
                                      style: TextStyle(
                                        color: proveedor
                                                    .estado ==
                                                "Activo"
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