import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingFullscreen extends StatelessWidget {
  const LoadingFullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
