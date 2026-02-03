import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/app/theme/app_colors.dart';
import 'package:petcare/core/api/api_endpoints.dart';
import 'package:petcare/core/providers/session_providers.dart';
import 'package:petcare/features/auth/presentation/pages/login.dart';
import 'package:petcare/features/auth/presentation/view_model/profile_view_model.dart';
import 'package:petcare/features/bottomnavigation/presentation/pages/edit_profile_screen.dart';
import 'package:petcare/features/pet/presentation/pages/my_pet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(profileViewModelProvider.notifier).loadProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionStateProvider);
    final profileState = ref.watch(profileViewModelProvider);

    final avatar = profileState.user?.avatar;
    final displayName = session.firstName ?? 'User';
    final displayEmail = session.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ================= HEADER =================
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppColors.iconPrimaryColor,
              elevation: 0,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: const EdgeInsets.only(bottom: 16),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      displayEmail,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.iconPrimaryColor, Color(0xFF9D6BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      backgroundImage: avatar != null && avatar.isNotEmpty
                          ? CachedNetworkImageProvider(
                              '${ApiEndpoints.mediaServerUrl}$avatar',
                            )
                          : null,
                      child: avatar == null || avatar.isEmpty
                          ? const Icon(
                              Icons.person_rounded,
                              size: 48,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),

            // ================= BODY =================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // -------- STATS --------
                    _buildStatsSection(),

                    const SizedBox(height: 40),

                    // -------- ACCOUNT --------
                    _buildMenuSection('Account', [
                      _MenuItem(
                        icon: Icons.edit_rounded,
                        title: 'Edit Profile',
                        subtitle: 'Update your details',
                        color: const Color(0xFF4ECFFF),
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );

                          if (updated == true) {
                            await ref
                                .read(profileViewModelProvider.notifier)
                                .loadProfile();
                            await ref
                                .read(sessionStateProvider.notifier)
                                .load();
                          }
                        },
                      ),
                      _MenuItem(
                        icon: Icons.pets_rounded,
                        title: 'My Pets',
                        subtitle: 'Manage your pets',
                        color: const Color(0xFFFF6B9D),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MyPet()),
                          );
                        },
                      ),
                    ]),

                    const SizedBox(height: 36),

                    // -------- PREFERENCES --------
                    _buildMenuSection('Preferences', [
                      _MenuItem(
                        icon: Icons.notifications_rounded,
                        title: 'Notifications',
                        subtitle: 'Alerts & reminders',
                        color: const Color(0xFF9D6BFF),
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.dark_mode_rounded,
                        title: 'Theme',
                        subtitle: 'Light mode',
                        color: const Color(0xFFFFB84D),
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 36),

                    // -------- SUPPORT --------
                    _buildMenuSection('Support', [
                      _MenuItem(
                        icon: Icons.help_rounded,
                        title: 'Help Center',
                        subtitle: 'Get help',
                        color: const Color(0xFF00D4FF),
                        onTap: () {},
                      ),
                    ]),

                    const SizedBox(height: 48),

                    // -------- LOGOUT --------
                    _buildLogoutButton(context),

                    const SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= STATS =================

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            Icons.pets_rounded,
            '3',
            'Pets',
            const Color(0xFFFF6B9D),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard(
            Icons.event_rounded,
            '5',
            'Visits',
            const Color(0xFF4ECFFF),
          ),
        ),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // ================= MENU =================

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(children: items.map(_menuItem).toList()),
        ),
      ],
    );
  }

  Widget _menuItem(_MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item.icon, color: item.color),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ================= LOGOUT =================

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Log Out',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Log out'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await ref
                        .read(sessionStateProvider.notifier)
                        .clearSession();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const Login()),
                      (_) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                  ),
                  child: const Text('Log Out'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

// ================= MENU MODEL =================

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.onTap,
  });
}
