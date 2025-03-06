import 'package:flutter/material.dart';

class DrawerNavItem {
  final IconData icon;
  final String title;
  final String routeName;
  final bool isSelected;

  DrawerNavItem({
    required this.icon,
    required this.title,
    required this.routeName,
    required this.isSelected,
  });
}
