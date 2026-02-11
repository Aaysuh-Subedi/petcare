import 'package:flutter/material.dart';
import 'package:petcare/app/theme/app_colors.dart';

class ProviderInventoryScreen extends StatelessWidget {
  const ProviderInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text('Your Inventory'),
        backgroundColor: AppColors.iconPrimaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Inventory management coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
