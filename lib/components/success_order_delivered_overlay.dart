import 'package:flutter/material.dart';

class SuccessOrderDeliveredOverlay extends StatelessWidget {
  final void Function() onPressed;

  const SuccessOrderDeliveredOverlay({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: Colors.black54),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/package_delivered.png',
              width: 72,
            ),
            const SizedBox(height: 10),
            Text(
              'Foto enviada!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              'Pacote entregue.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onPressed, child: Text('Voltar')),
          ],
        ),
      ),
    );
  }
}
