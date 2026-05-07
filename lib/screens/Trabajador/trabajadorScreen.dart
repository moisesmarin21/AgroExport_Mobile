import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/core/widgets/trabajador_form.dart';
import 'package:consorcio_app/providers/trabajador_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrabajadorScreen extends StatefulWidget {
  const TrabajadorScreen({super.key});

  @override
  State<TrabajadorScreen> createState() => _TrabajadorScreenState();
}

class _TrabajadorScreenState extends State<TrabajadorScreen> {
  String searchQuery = "";

  Future<void> _loadData() async {
    final provider = Provider.of<TrabajadorProvider>(context, listen: false);
    await provider.getTrabajadores();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadData());
  }

  Future<void> _goToForm({dynamic trabajador}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrabajadorForm(
          trabajador: trabajador,
          onSubmit: (data) {},
        ),
      ),
    );

    // 🔥 RECARGA AUTOMÁTICA AL VOLVER
    await _loadData();
    setState(() {});
  }

  List<dynamic> _filterTrabajadores(List<dynamic> list) {
    if (searchQuery.isEmpty) return list;

    return list.where((t) {
      final fullName =
          "${t.nombres.toString().toLowerCase()} ${t.apellidos.toString().toLowerCase()}";
      final area = t.areaNombre.toString().toLowerCase();
      final cargo = t.cargo.toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return fullName.contains(query) ||
          area.contains(query) ||
          cargo.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrabajadorProvider>(context);
    final trabajadores = _filterTrabajadores(provider.trabajadores);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Trabajadores",
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
                // Buscador
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: "Buscar por nombre, área o cargo...",
                      hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      prefixIcon: const Icon(Icons.search, size: 18,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                      contentPadding: EdgeInsets.all(8)
                    ),
                    style: const TextStyle(fontSize: 14),
                    onChanged: (v) {
                      setState(() {
                        searchQuery = v;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: trabajadores.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay trabajadores registrados",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: trabajadores.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final trabajador = trabajadores[index];

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _goToForm(trabajador: trabajador),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${trabajador.nombres} ${trabajador.apellidos}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Cargo: ${trabajador.cargo}",
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Area: ${trabajador.areaNombre}",
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
                                            trabajador.areaNombre,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: trabajador.activo == true
                                                  ? Colors.green.withOpacity(0.15)
                                                  : Colors.red.withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              trabajador.activo == true
                                                  ? "Activo"
                                                  : "Inactivo",
                                              style: TextStyle(
                                                color: trabajador.activo == true
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
}