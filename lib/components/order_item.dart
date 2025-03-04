import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:fast_feet_app/models/order.dart';
import 'package:fast_feet_app/@types/order_status.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fast_feet_app/screens/order_details_screen.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  PhosphorIconsFill.package,
                  size: 32,
                ),
                const SizedBox(width: 10),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style:
                          GoogleFonts.robotoMono(fontWeight: FontWeight.bold),
                    ),
                    Text(DateFormat('dd/MM/yyyy').format(order.postedAt)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 70),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTimeLineTitle(
                      isFirst: true,
                      isLast: false,
                      isPast: true,
                      status: 'AGUARDANDO',
                    ),
                  ),
                  Expanded(
                    child: CustomTimeLineTitle(
                      isFirst: false,
                      isLast: false,
                      isPast: order.withdrawalAt != null,
                      status: 'RETIRADO',
                    ),
                  ),
                  Expanded(
                    child: CustomTimeLineTitle(
                      isFirst: false,
                      isLast: true,
                      isPast: order.status == OrderStatus.entregue,
                      status: 'ENTREGUE',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            color: AppColors.lightYellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Detalhes'),
                IconButton(
                  icon: Icon(Icons.arrow_right_alt_rounded),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.orderDetails,
                      arguments: order.id,
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomTimeLineTitle extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String status;

  const CustomTimeLineTitle(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.status});

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      axis: TimelineAxis.horizontal,
      alignment: TimelineAlign.center,
      isFirst: isFirst,
      isLast: isLast,
      beforeLineStyle: LineStyle(
        color: isPast ? Colors.deepPurple : Colors.deepPurple.shade100,
        thickness: 4,
      ),
      indicatorStyle: IndicatorStyle(
        height: 22,
        color: isPast ? Colors.deepPurple : Colors.deepPurple.shade100,
        iconStyle: IconStyle(iconData: Icons.done, color: Colors.white),
      ),
      endChild: Column(
        children: [
          SizedBox(height: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isPast ? Colors.deepPurple : Colors.deepPurple.shade100,
            ),
          ),
        ],
      ),
    );
  }
}
