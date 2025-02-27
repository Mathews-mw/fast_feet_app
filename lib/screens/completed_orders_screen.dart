import 'package:fast_feet_app/components/order_item.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CompletedOrders extends StatelessWidget {
  const CompletedOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (ctx, i) {
            return OrderItem();
          },
        ),
      ),
    );
  }
}
