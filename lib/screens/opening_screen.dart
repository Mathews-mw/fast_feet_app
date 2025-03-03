import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/providers/user_provider.dart';
import 'package:fast_feet_app/services/auth_service.dart';
import 'package:fast_feet_app/services/http_service.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  bool _isAuthenticated = false;
  bool _isRequestCompleted = false;
  bool _isAnimationCompleted = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      final httpService = HttpService();
      final authService = AuthService();
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.loadUserData();
      final token = await authService.getToken();

      if (userProvider.user != null && token != null) {
        await httpService.refreshToken();
        _isAuthenticated = true;
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
      _isAuthenticated = false;
    }

    setState(() {
      _isRequestCompleted = true;
    });

    if (_isAnimationCompleted) {
      _redirectUser();
    }
  }

  void _redirectUser() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      _isAuthenticated ? AppRoutes.home : AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple,
      extendBody: true,
      body: Center(
        child: _isAnimationCompleted && !_isRequestCompleted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    'Carregando dados...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : Image.asset(
                'assets/images/logo.png',
                width: 62,
              )
                .animate()
                .fadeIn(duration: 500.ms, curve: Curves.easeIn)
                .moveX(
                    begin: -50,
                    end: 0,
                    curve: Curves.easeInOut,
                    duration: 1000.ms)
                .then()
                .scaleXY(
                    begin: 1, end: 1.25, curve: Curves.easeIn, duration: 800.ms)
                .then(duration: 800.ms)
                .scaleXY(begin: 1.25, end: 1, curve: Curves.easeOut)
                .then(duration: 500.ms)
                .moveX(
                    begin: 0,
                    end: 50,
                    curve: Curves.easeInOut,
                    duration: 1000.ms)
                .fadeOut()
                .then()
                .callback(
                  duration: 0.ms,
                  callback: (_) {
                    setState(() => _isAnimationCompleted = true);

                    if (_isRequestCompleted) {
                      _redirectUser();
                    }
                  },
                ),
      ),
    );
  }
}
