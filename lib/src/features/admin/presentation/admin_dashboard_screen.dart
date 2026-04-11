import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iceberg_app/src/core/theme/iceberg_theme.dart';
import '../../../core/layout/responsive_layout.dart';
import '../../auth/application/auth_controller.dart';
import 'widgets/admin_overview_content.dart';
import 'widgets/product_management_content.dart';
import 'widgets/order_history_content.dart';
import 'widgets/staff_management_content.dart';
import 'widgets/settings_content.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedIndex = 0;

  static const _destinations = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Overview'),
    _NavItem(Icons.inventory_2_outlined, Icons.inventory_2, 'Products'),
    _NavItem(Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'),
    _NavItem(Icons.people_outline, Icons.people, 'Staff'),
    _NavItem(Icons.settings_outlined, Icons.settings, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navigate back to Overview tab instead of leaving
          setState(() => _selectedIndex = 0);
        }
      },
      child: ResponsiveLayout(
        mobile: _buildMobileBase(context, auth),
        desktop: _buildDesktopBase(context, auth),
      ),
    );
  }

  Widget _buildMobileBase(BuildContext context, dynamic auth) {
    return Scaffold(
      appBar: _buildAppBar(context, auth),
      body: _buildMainContent(context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDesktopBase(BuildContext context, dynamic auth) {
    final bool isExtended = ResponsiveLayout.isDesktop(context);

    return Scaffold(
      appBar: _buildAppBar(context, auth),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (idx) =>
                setState(() => _selectedIndex = idx),
            labelType: isExtended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            extended: isExtended,
            destinations: _destinations
                .map((d) => NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ))
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildMainContent(context)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, dynamic auth) {
    final staffName = auth?.name ?? 'Admin';

    return AppBar(
      titleSpacing: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/iceberg_logo.jpg',
            height: 36,
          ),
          const SizedBox(width: 10),
          const Text('Admin',
              style: TextStyle(
                  color: IcebergTheme.darkSlate,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
        ],
      ),
      backgroundColor: IcebergTheme.white,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: IcebergTheme.darkSlate),
        onPressed: () {
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
          } else {
            context.go('/pos');
          }
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: IcebergTheme.creamPink,
                child: Text(
                  staffName.isNotEmpty ? staffName[0].toUpperCase() : 'A',
                  style: const TextStyle(
                    color: IcebergTheme.vibrantRosePink,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(staffName,
                  style: const TextStyle(
                      color: IcebergTheme.darkSlate,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.point_of_sale,
              color: IcebergTheme.vibrantRosePink),
          onPressed: () => context.go('/pos'),
          tooltip: 'Go to POS',
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        return const AdminOverviewContent();
      case 1:
        return const ProductManagementContent();
      case 2:
        return const OrderHistoryContent();
      case 3:
        return const StaffManagementContent();
      case 4:
        return const SettingsContent();
      default:
        return const AdminOverviewContent();
    }
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem(this.icon, this.selectedIcon, this.label);
}
