import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/core/widgets/app_bar_module.dart';
import 'package:consorcio_app/providers/auth_provider.dart';
import 'package:consorcio_app/routes/app_routes.dart';
import 'package:consorcio_app/screens/Actividad/actividadScreen.dart';
import 'package:consorcio_app/screens/Material/materialScreen.dart';
import 'package:consorcio_app/screens/Proveedor/proveedorScreen.dart';
import 'package:consorcio_app/screens/Reportes/dashboardScreen.dart';
import 'package:consorcio_app/screens/Tareo/tareoScreen.dart';
import 'package:consorcio_app/screens/Trabajador/trabajadorScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Adminmodule extends StatefulWidget {
  const Adminmodule({super.key});

  @override
  State<Adminmodule> createState() => _AdminmoduleState();
}

class _AdminmoduleState extends State<Adminmodule> {

  final List<_MenuOption> options = [
    _MenuOption("Trabajador", Icons.person, TrabajadorScreen()),
    _MenuOption("Actividad", Icons.local_activity, ActividadScreen()),
    _MenuOption("Tareo", Icons.work, TareoScreen()),
    _MenuOption("Material", Icons.inventory, MaterialScreen()),
    _MenuOption("Proveedor", Icons.person, Proveedorscreen()),
    _MenuOption("Reportes", Icons.bar_chart, DashboardScreen()),
  ];

  void _onOptionSelected(_MenuOption option) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => option.page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _DashboardGrid(
          options: options,
          onTap: _onOptionSelected,
        ),
      ),
    );
  }

  final GlobalKey _settingsKey = GlobalKey();

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBarModule(
      title: "Panel de Trabajo",
      actions: [
        IconButton(
          key: _settingsKey,
          icon: Icon(Icons.settings),
          onPressed: _showSettingsDropdown,
        ),
      ],
    );
  }

  void _showSettingsDropdown() {
    final RenderBox button = _settingsKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final offset = button.localToGlobal(Offset.zero, ancestor: overlay);

    final position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + button.size.height + 4,
      overlay.size.width - offset.dx - button.size.width,
      0,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Perfil"),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.perfil,
            );
          },
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text("Cerrar Sesión"),
          ),
          onTap: () async {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);

            await authProvider.logout();

            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        ),
      ],
    );
  }
}

class _MenuOption {
  final String title;
  final IconData icon;
  final Widget page;

  _MenuOption(this.title, this.icon, this.page);
}

class _DashboardGrid extends StatelessWidget {
  final List<_MenuOption> options;
  final Function(_MenuOption) onTap;

  const _DashboardGrid({
    required this.options,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final option = options[index];

        return _DashboardCard(
          title: option.title,
          icon: option.icon,
          onTap: () => onTap(option),
        );
      },
    );
  }
}


class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green.shade50,
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}