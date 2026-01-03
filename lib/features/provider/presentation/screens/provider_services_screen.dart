import 'package:flutter/material.dart';
import 'package:petcare/app/theme/app_colors.dart';

class ProviderServicesScreen extends StatelessWidget {
  const ProviderServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Services'),
        backgroundColor: AppColors.iconPrimaryColor,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Services management coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
