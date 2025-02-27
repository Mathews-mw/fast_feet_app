import 'package:fast_feet_app/screens/order_details_screen.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      PhosphorIconsFill.package,
                      size: 32,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Pacote 06',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Text('25/02/2025'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 70),
              child: Row(
                children: const [
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
                      isPast: true,
                      status: 'RETIRADO',
                    ),
                  ),
                  Expanded(
                    child: CustomTimeLineTitle(
                      isFirst: false,
                      isLast: true,
                      isPast: false,
                      status: 'ENTREGUE',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            color: Colors.yellow.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Detalhes'),
                IconButton(
                  icon: Icon(Icons.arrow_right_alt_rounded),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) {
                        return OrderDetailsScreen();
                      }),
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
