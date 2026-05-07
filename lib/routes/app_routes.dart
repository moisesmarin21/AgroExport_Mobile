import 'package:consorcio_app/screens/adminModule.dart';
import 'package:consorcio_app/screens/fontPage.dart';
import 'package:consorcio_app/screens/forgot_password_screen.dart';
import 'package:consorcio_app/screens/loginScreen.dart';
import 'package:consorcio_app/screens/perfilScreen.dart';
import 'package:consorcio_app/screens/reset_password_screen.dart';
import 'package:consorcio_app/screens/verify_code_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  // LOGIN
  static const String fontPage = '/';
  static const String login = '/login';
  static const String adminModule = '/adminModule';

  static const String perfil = '/perfil';

  static const String forgotPassword = '/forgot';
  static const String verifyCode = '/verifyCode';
  static const String resetPassword = '/reset';

  // Mapa de rutas
  static Map<String, WidgetBuilder> routes = {
    // LOGIN
    fontPage: (context) => FontPage(),
    login: (context) => LoginScreen(),

    perfil: (context) => PerfilScreen(),

    forgotPassword: (context) => ForgotPasswordScreen(),
    verifyCode: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      return VerifyCodeScreen(email: args['email']!);
    },
    resetPassword: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      return ResetPasswordScreen(email: args['email']!);
    },

    // ADMINISTRADOR
    adminModule: (context) => Adminmodule(),

  };
}
