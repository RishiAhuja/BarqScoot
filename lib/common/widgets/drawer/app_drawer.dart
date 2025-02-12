import 'package:escooter/common/widgets/drawer/widgets/drawer_items.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Text(
            'Barq Scoot',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(
            height: 30,
          ),
          AppDrawerItems(),
        ],
      ),
    );
  }
}
