import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/actividad_provider.dart';
import 'package:consorcio_app/providers/material_provider.dart';
import 'package:consorcio_app/providers/proveedor_provider.dart';
import 'package:consorcio_app/providers/tareo_provider.dart';
import 'package:consorcio_app/providers/trabajador_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      final proveedorProvider = Provider.of<ProveedorProvider>(context, listen: false);
      final materialProvider = Provider.of<MaterialProvider>(context, listen: false);
      final trabajadorProvider = Provider.of<TrabajadorProvider>(context, listen: false);
      final actividadProvider = Provider.of<ActividadProvider>(context, listen: false);
      final tareoProvider = Provider.of<TareoProvider>(context, listen: false);

      await proveedorProvider.getProveedores();
      await materialProvider.getMateriales();
      await trabajadorProvider.getTrabajadores();
      await actividadProvider.getActividades();
      await tareoProvider.getTareos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final proveedores = Provider.of<ProveedorProvider>(context).proveedores;
    final materiales = Provider.of<MaterialProvider>(context).materiales;
    final trabajadores = Provider.of<TrabajadorProvider>(context).trabajadores;
    final actividades = Provider.of<ActividadProvider>(context).actividades;

    double? campoCount = actividades.where((t) => t.areaNombre == 'Campo').length.toDouble();
    double? laboratorioCount = actividades.where((t) => t.areaNombre == 'Laboratorio').length.toDouble();
    double? viveroCount = actividades.where((t) => t.areaNombre == 'Vivero').length.toDouble();
    double? administrativoCount = actividades.where((t) => t.areaNombre == 'Trabajo Administrativo').length.toDouble();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARDS RESUMEN
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: 'Trabajadores',
                    value: trabajadores.length.toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    title: 'Actividades',
                    value: actividades.length.toString(),
                    icon: Icons.assignment,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: 'Materiales',
                    value: materiales.length.toString(),
                    icon: Icons.inventory,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    title: 'Proveedores',
                    value: proveedores.length.toString(),
                    icon: Icons.local_shipping,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // TAREOS
            _buildSectionTitle('Resumen de Tareos'),
            const SizedBox(height: 10),
            _buildTareoCard(),

            const SizedBox(height: 20),

            // GRAFICO ACTIVIDADES
            _buildSectionTitle('Estado de Actividades'),
            const SizedBox(height: 10),
            _buildActivitiesChart(
              campoCount: campoCount,
              laboratorioCount: laboratorioCount,
              viveroCount: viveroCount,
              administrativoCount: administrativoCount,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTareoCard() {
    final tareos = Provider.of<TareoProvider>(context).tareos;
    final totalRegistros = tareos.length;
    final totalPagado = tareos.fold(0.0, (sum, tareo) => sum + tareo.totalCosto);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TareoItem(
              label: 'Total Pagado',
              value: '\S/. ${totalPagado.toStringAsFixed(2)}',
            ),
          ),
          Expanded(
            child: _TareoItem(
              label: 'Total Registros',
              value: totalRegistros.toString(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesChart({
    required double campoCount,
    required double laboratorioCount,
    required double viveroCount,
    required double administrativoCount,
  }) {
    final maxValue = [
      campoCount,
      laboratorioCount,
      viveroCount,
      administrativoCount
    ].reduce((a, b) => a > b ? a : b);

    final maxY = (maxValue <= 5)
        ? 5
        : (maxValue <= 10)
            ? 10
            : (maxValue <= 15)
                ? 15
                : (maxValue + 5).ceilToDouble();

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: _chartDecoration(),
      child: BarChart(
        BarChartData(
          maxY: maxY.toDouble(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('Campo', style: TextStyle(fontSize: 12));
                    case 1:
                      return const Text('Laboratorio', style: TextStyle(fontSize: 12));
                    case 2:
                      return const Text('Vivero', style: TextStyle(fontSize: 12));
                    case 3:
                      return const Text('Administrativo', style: TextStyle(fontSize: 12));
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(toY: campoCount, color: Colors.green)
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(toY: laboratorioCount, color: Colors.orange)
            ]),
            BarChartGroupData(x: 2, barRods: [
              BarChartRodData(toY: viveroCount, color: Colors.red)
            ]),
            BarChartGroupData(x: 3, barRods: [
              BarChartRodData(toY: administrativoCount, color: Colors.blue)
            ]),
          ],
        ),
      ),
    );
  }

  BoxDecoration _chartDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class _TareoItem extends StatelessWidget {
  final String label;
  final String value;

  const _TareoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}