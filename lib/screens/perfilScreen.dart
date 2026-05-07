import 'package:consorcio_app/core/widgets/app_bar.dart';
import 'package:consorcio_app/providers/auth_provider.dart';
import 'package:consorcio_app/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final session = Provider.of<AuthProvider>(context, listen: false).session;
      if (session == null) return;
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      usuarioProvider.getUsuarioById(session.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);
    final usuario = usuarioProvider.usuario;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Perfil",
      ),
      body: usuarioProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : usuarioProvider.error != null
              ? Center(child: Text(usuarioProvider.error!))
              : usuario == null
                  ? const Center(child: Text("No se encontró usuario"))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildHeader(usuario.usuario),
                          const SizedBox(height: 20),
                          _buildInfoCard(usuario),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildHeader(String nombre) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(
            Icons.person,
            size: 50,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          nombre,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(dynamic usuario) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        children: [
          _buildItem(
            icon: Icons.person,
            title: "Usuario",
            value: usuario.usuario,
          ),
          _divider(),
          _buildItem(
            icon: Icons.email,
            title: "Correo",
            value: usuario.email,
          ),
          _divider(),
          _buildItem(
            icon: Icons.security,
            title: "Rol",
            value: usuario.rol,
          ),
          _divider(),
          _buildItem(
            icon: Icons.verified,
            title: "Estado",
            value: usuario.activo ? "Activo" : "Inactivo",
            valueColor: usuario.activo ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = Colors.black87,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 1,
    );
  }
}