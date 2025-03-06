import 'package:fast_feet_app/components/app_drawer/app_drawer.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CreateOrder extends StatelessWidget {
  const CreateOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Novo pedido',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Text('Ciar novo pedido'),
      ),
    );
  }
}
