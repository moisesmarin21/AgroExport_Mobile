import 'package:consorcio_app/core/constants/app_textField.dart';
import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/spacing.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();

  bool isLoading = false;
  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();

    emailCtrl.addListener(() {
      final email = emailCtrl.text.trim();
      final emailRegex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      );

      setState(() {
        isEmailValid = emailRegex.hasMatch(email);
      });
    });
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(AuthProvider authProvider) async {
    if (!isEmailValid || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      await authProvider.forgotPassword(emailCtrl.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código enviado al correo exitosamente'),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.pushNamed(
        context,
        "/verifyCode",
        arguments: {
          'email': emailCtrl.text.trim(),
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );

      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: IconButton(
                                      onPressed: isLoading
                                          ? null
                                          : () {
                                              Navigator.pop(context);
                                            },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Recuperar Contraseña',
                                    style: AppStyles.title,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        Text('Correo', style: AppStyles.inputLabel),

                        AppTextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 12),

                        /// 📩 Correo de referencia bloqueado
                        if (isEmailValid)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Text(
                              "El código de recuperación será enviado a:\n${emailCtrl.text.trim()}",
                              style: AppStyles.labelSmall
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: AppButtonStyles.primary,
                              onPressed: (isEmailValid && !isLoading)
                                  ? () => _handleSubmit(authProvider)
                                  : null,
                              child: isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Enviando...', style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )
                                  : const Text(
                                      'Enviar',
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}