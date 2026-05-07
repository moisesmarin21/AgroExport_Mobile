import 'package:consorcio_app/core/constants/app_textField.dart';
import 'package:consorcio_app/core/constants/buttons.dart';
import 'package:consorcio_app/core/constants/colors.dart';
import 'package:consorcio_app/core/constants/spacing.dart';
import 'package:consorcio_app/core/constants/styles.dart';
import 'package:consorcio_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  const VerifyCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyCodeScreen> createState() =>
      _VerifyCodeScreenState();
}

class _VerifyCodeScreenState
    extends State<VerifyCodeScreen> {
  bool _activarBoton = false;
  bool isSubmitting = false;
  bool isResending = false;

  final emailCtrl = TextEditingController();
  final codeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailCtrl.text = widget.email;
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    codeCtrl.dispose();
    super.dispose();
  }

  void _validateFields() {
    final isValid = codeCtrl.text.length == 6;

    setState(() {
      _activarBoton = isValid;
    });
  }

  final defaultPinTheme = PinTheme(
    width: 50,
    height: 60,
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
    ),
  );

  Future<void> _handleResend(AuthProvider authProvider) async {
    if (isResending) return;

    setState(() {
      isResending = true;
    });

    try {
      await authProvider.forgotPassword(emailCtrl.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de verificación reenviado'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al enviar código de verificación'),
          duration: Duration(seconds: 3),
        ),
      );

      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isResending = false;
        });
      }
    }
  }

  Future<void> _handleSubmit(AuthProvider authProvider) async {
    if (!_activarBoton || isSubmitting) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      await authProvider.verifyCode(
        widget.email,
        codeCtrl.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código verificado exitosamente'),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.pushNamed(
        context,
        "/reset",
        arguments: {
          'email': emailCtrl.text.trim(),
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );

      debugPrint('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
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
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(20)),
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
                                      onPressed: (isSubmitting || isResending)
                                          ? null
                                          : () => Navigator.pop(context),
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Text('Verificar Cuenta', style: AppStyles.title),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        Text('Correo electrónico', style: AppStyles.labelLargeGreen),
                        AppTextField(
                          padding: const EdgeInsets.only(bottom: 10),
                          controller: emailCtrl,
                          enabled: false,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: isResending
                                  ? null
                                  : () =>
                                      _handleResend(authProvider),
                              child: isResending
                                  ? Row(
                                      children: const [
                                        SizedBox(
                                          width: 14,
                                          height: 14,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('Enviando...', style: TextStyle(color: Colors.grey)),
                                      ],
                                    )
                                  : Text('Reenviar código', style: AppStyles.labelGreen),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        Text('Código de Verificación', style: AppStyles.labelLargeGreen),
                        const SizedBox(height: AppSpacing.md),

                        Pinput(
                          controller: codeCtrl,
                          length: 6,
                          keyboardType: TextInputType.number,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                          ),
                          onChanged: (_) => _validateFields(),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        Center(
                          child: ElevatedButton(
                            style: AppButtonStyles.primary,
                            onPressed: (_activarBoton &&
                                    !isSubmitting)
                                ? () => _handleSubmit(
                                    authProvider)
                                : null,
                            child: isSubmitting
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: const [
                                      SizedBox(
                                        width: 18,
                                        height: 18,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Enviando...', style: AppStyles.buttonWhiteText),
                                    ],
                                  )
                                : Text('Restablecer Contraseña', style: AppStyles.buttonWhiteText),
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