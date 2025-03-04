import 'package:flutter/material.dart';

class PickupOrderOverlay extends StatelessWidget {
  final void Function() onPressed;

  const PickupOrderOverlay({super.key, required this.onPressed});

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
              'assets/images/recebido.png',
              width: 72,
            ),
            const SizedBox(height: 10),
            Text(
              'Pacote retirado!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              'Só falta entregar :)',
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
