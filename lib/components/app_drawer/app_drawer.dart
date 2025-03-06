import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/components/app_drawer/drawer_nav_item.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    final List<DrawerNavItem> drawerItems = [
      DrawerNavItem(
        icon: PhosphorIconsFill.house,
        title: 'Home',
        routeName: AppRoutes.home,
        isSelected: currentRoute == AppRoutes.home,
      ),
      DrawerNavItem(
        icon: Icons.list_alt,
        title: 'Pedidos',
        routeName: AppRoutes.orders,
        isSelected: currentRoute == AppRoutes.orders,
      ),
      DrawerNavItem(
        icon: PhosphorIconsFill.package,
        title: 'Novo Pedido',
        routeName: AppRoutes.createOrder,
        isSelected: currentRoute == AppRoutes.createOrder,
      ),
      DrawerNavItem(
        icon: PhosphorIconsFill.users,
        title: 'Destinatários',
        routeName: AppRoutes.recipients,
        isSelected: currentRoute == AppRoutes.recipients,
      ),
    ];

    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Fast Feet',
              style: TextStyle(
                color: AppColors.textAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: const Text(''),
            currentAccountPicture: Image.asset(
              'assets/images/logo.png',
            ),
            currentAccountPictureSize: const Size.square(52),
            decoration: const BoxDecoration(
              color: AppColors.purple,
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: drawerItems.length,
            itemBuilder: (ctx, i) {
              return _buildDrawerItem(
                ctx,
                icon: drawerItems[i].icon,
                title: drawerItems[i].title,
                routeName: drawerItems[i].routeName,
                isSelected: drawerItems[i].isSelected,
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String routeName,
    required bool isSelected,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.purple : AppColors.textLight,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.purple : AppColors.textLight,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.deepPurple.shade100,
      onTap: () {
        Navigator.pop(context); // Fecha o Drawer
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}
