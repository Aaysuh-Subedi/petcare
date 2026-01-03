import 'package:flutter/material.dart';
import 'package:petcare/app/theme/app_colors.dart';
import 'package:petcare/features/provider/presentation/screens/provider_inventory_screen.dart';
import 'package:petcare/features/provider/presentation/screens/provider_services_screen.dart';

class ProviderDashboardScreen extends StatelessWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
        backgroundColor: AppColors.iconPrimaryColor,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle(context, 'Your Business'),
          _dashCard(
            context,
            title: 'Services',
            subtitle: 'Manage services you offer',
            icon: Icons.medical_services_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProviderServicesScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _dashCard(
            context,
            title: 'Inventory',
            subtitle: 'Track your products & stock',
            icon: Icons.inventory_2_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProviderInventoryScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'Operations'),
          _dashCard(
            context,
            title: 'Bookings',
            subtitle: 'Upcoming & past appointments',
            icon: Icons.event_note_rounded,
            onTap: () {
              // TODO: Wire to booking screen when available
            },
          ),
          const SizedBox(height: 16),
          _dashCard(
            context,
            title: 'Messages',
            subtitle: 'Chat with pet owners',
            icon: Icons.chat_bubble_rounded,
            onTap: () {
              // TODO: Wire to messaging screen when available
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _dashCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.iconPrimaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}
