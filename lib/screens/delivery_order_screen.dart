import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:fast_feet_app/services/http_service.dart';
import 'package:fast_feet_app/components/loading_overlay.dart';
import 'package:fast_feet_app/components/success_order_delivered_overlay.dart';

class DeliveryOrderScreen extends StatefulWidget {
  const DeliveryOrderScreen({super.key});

  @override
  State<DeliveryOrderScreen> createState() => _DeliveryOrderScreenState();
}

class _DeliveryOrderScreenState extends State<DeliveryOrderScreen> {
  bool _isLoading = false;
  bool _isSuccessDelivered = false;
  File? _pickedImage;

  Future<void> _takePicture() async {
    final ImagePicker _picker = ImagePicker();

    final imageFromCamera = await _picker.pickImage(source: ImageSource.camera);

    if (imageFromCamera == null) return;

    setState(() {
      _pickedImage = File(imageFromCamera.path);
    });
  }

  Future<void> handleCompleteOrder() async {
    setState(() => _isSuccessDelivered = false);
    setState(() => _isLoading = true);

    final httpService = HttpService();

    if (_pickedImage == null) return;

    final response = await httpService.multiPartRequest(
      'orders/cc5abfbe-b200-4d71-9ffc-be0ea9e73a32/delivered?lat=-3.0582755168191174&long=-60.011960427593905',
      _pickedImage!,
    );

    if (response != 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocorreu um erro ao tentar fazer o upload da imagem.',
          ),
        ),
      );

      setState(() => _isLoading = false);
      setState(() => _isSuccessDelivered = false);
      return;
    }

    setState(() => _isLoading = false);
    setState(() => _isSuccessDelivered = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Confirmar entrega',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        if (_pickedImage != null)
                          Expanded(
                            child: Image.file(
                              _pickedImage!,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
                                iconSize: 32,
                                padding: EdgeInsets.all(12),
                              ),
                              icon: const Icon(
                                PhosphorIconsFill.camera,
                                color: Colors.white,
                              ),
                              onPressed: _takePicture,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tire uma foto do pacote com a assinatura do destinatário para confirmar a entrega.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Enviar foto'),
                  onPressed: () async {
                    await handleCompleteOrder();
                  },
                ),
              ],
            ),
          ),
          if (_isLoading) LoadingOverlay(),
          if (_isSuccessDelivered)
            SuccessOrderDeliveredOverlay(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
