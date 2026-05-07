import 'package:consorcio_app/app.dart';
import 'package:consorcio_app/providers/actividad_provider.dart';
import 'package:consorcio_app/providers/area_provider.dart';
import 'package:consorcio_app/providers/material_provider.dart';
import 'package:consorcio_app/providers/proveedor_provider.dart';
import 'package:consorcio_app/providers/tareo_provider.dart';
import 'package:consorcio_app/providers/tipoSueldo_provider.dart';
import 'package:consorcio_app/providers/trabajador_provider.dart';
import 'package:consorcio_app/providers/usuario_provider.dart';
import 'package:consorcio_app/services/actividad_service.dart';
import 'package:consorcio_app/services/area_service.dart';
import 'package:consorcio_app/services/material_service.dart';
import 'package:consorcio_app/services/proveedor_service.dart';
import 'package:consorcio_app/services/tareo_service.dart';
import 'package:consorcio_app/services/tipoSueldo_service.dart';
import 'package:consorcio_app/services/trabajador_service.dart';
import 'package:consorcio_app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final apiClient = ApiClient();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => ProveedorProvider(ProveedorService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => ActividadProvider(ActividadService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => TrabajadorProvider(TrabajadorService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => MaterialProvider(MaterialService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => AreaProvider(AreaService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => TareoProvider(TareoService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => UsuarioProvider(UsuarioService(apiClient)),
        ),
        ChangeNotifierProvider(
          create: (_) => TipoSueldoProvider(TipoSueldoService(apiClient)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}