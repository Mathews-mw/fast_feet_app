import 'package:fast_feet_app/@exceptions/api_exceptions.dart';
import 'package:fast_feet_app/@mixins/form_validations_mixin.dart';
import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/components/custom_text_field.dart';
import 'package:fast_feet_app/components/loading_overlay.dart';
import 'package:fast_feet_app/providers/user_provider.dart';
import 'package:fast_feet_app/services/auth_service.dart';
import 'package:fast_feet_app/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FormValidationsMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleSubmitForm() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      return;
    }

    formKey.currentState?.save();

    try {
      final httpService = HttpService();
      final authService = AuthService();

      final response = await httpService.post('auth', {
        'email': formData['email'],
        'password': formData['password'],
      });

      authService.saveToken(response['token']);

      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false).loadUserData();

        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (route) => false,
        );
      }

      setState(() => _isLoading = false);
    } on ApiExceptions catch (error) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message,
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocorreu um erro inesperado. Tente novamente.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    formData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Expanded(
              child: Container(
                child: Image.asset('assets/images/foreground.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 40,
                      ),
                      Image.asset('assets/images/logo_text.png'),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Entregador,',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w900,
                              fontSize: 38,
                              fontStyle: FontStyle.italic,
                              color: AppColors.yellow,
                            ),
                          ),
                          Text(
                            'você é nosso',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              letterSpacing: 0.2,
                              height: 0.5,
                            ),
                          ),
                          Text(
                            'maior valor',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          )
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faça seu login para',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'começar suas entregas.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          enabled: !_isLoading,
                          hintText: 'E-mail',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.email),
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            formData['email'] = value ?? '';
                          },
                          validator: (value) => combine(
                            [
                              () => isNotEmpty(value),
                              () => isEmail(
                                    value,
                                    'Por favor, informe um e-mail válido.',
                                  )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          enabled: !_isLoading,
                          hintText: 'Senha',
                          obscureText: true,
                          prefixIcon: Icon(Icons.lock),
                          controller: _passwordController,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['password'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Esqueci minha senha',
                            style: TextStyle(
                              color: Colors.grey.shade100,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                child: const Text('Entrar'),
                                onPressed: () => handleSubmitForm(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}
