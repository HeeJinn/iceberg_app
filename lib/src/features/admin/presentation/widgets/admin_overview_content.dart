import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../../core/layout/responsive_layout.dart';
import '../../application/admin_analytics_controller.dart';
import 'sales_line_chart.dart';
import 'category_pie_chart.dart';
import 'hourly_bar_chart.dart';

class AdminOverviewContent extends ConsumerWidget {
  const AdminOverviewContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(adminAnalyticsProvider);
    final isMobile = ResponsiveLayout.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard Overview',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Real-time analytics from your POS transactions',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 24),

          // Stats Cards
          _buildStatsGrid(context, analytics, isMobile),
          const SizedBox(height: 24),

          // Charts
          if (isMobile) ...[
            SalesLineChart(weeklyTrend: analytics.weeklyTrend),
            const SizedBox(height: 16),
            CategoryPieChart(categoryRevenue: analytics.categoryRevenue),
            const SizedBox(height: 16),
            HourlyBarChart(hourlyOrders: analytics.hourlyOrders),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: SalesLineChart(weeklyTrend: analytics.weeklyTrend),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: CategoryPieChart(
                      categoryRevenue: analytics.categoryRevenue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            HourlyBarChart(hourlyOrders: analytics.hourlyOrders),
          ],

          const SizedBox(height: 24),

          // Top Products
          Text('Top Selling Products',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: analytics.topProducts.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text('No sales data yet. Start selling!',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: analytics.topProducts.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final p = analytics.topProducts[index];
                      return ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: IcebergTheme.creamPink.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: IcebergTheme.vibrantRosePink,
                              ),
                            ),
                          ),
                        ),
                        title: Text(p.productTitle,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${p.quantitySold} sold'),
                        trailing: Text(
                          '\$${p.revenue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: IcebergTheme.vibrantRosePink,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(
      BuildContext context, AnalyticsData analytics, bool isMobile) {
    final cards = [
      _StatInfo("Today's Sales",
          '\$${analytics.todaysSales.toStringAsFixed(2)}', Icons.attach_money,
          IcebergTheme.vibrantRosePink),
      _StatInfo('Total Orders', '${analytics.todaysOrderCount}',
          Icons.shopping_bag, const Color(0xFF4FC3F7)),
      _StatInfo(
          'Avg Order',
          '\$${analytics.averageOrderValue.toStringAsFixed(2)}',
          Icons.trending_up,
          IcebergTheme.mintBlueDark),
      _StatInfo('Top Product', analytics.topProduct, Icons.star,
          const Color(0xFFFFB74D)),
    ];

    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: cards.map((c) => _buildStatCard(c)).toList(),
      );
    }

    return Row(
      children: cards
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildStatCard(c),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildStatCard(_StatInfo info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: info.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(info.icon, color: info.color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(info.title,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text(
              info.value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatInfo {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  _StatInfo(this.title, this.value, this.icon, this.color);
}
