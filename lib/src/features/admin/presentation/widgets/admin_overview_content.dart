import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iceberg_app/src/core/utils/currency.dart';
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
          Text(
            'Dashboard Overview',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Real-time analytics from your POS transactions',
            style: TextStyle(color: Colors.grey.shade600),
          ),
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
                    categoryRevenue: analytics.categoryRevenue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            HourlyBarChart(hourlyOrders: analytics.hourlyOrders),
          ],

          const SizedBox(height: 24),

          // Top Products
          Text(
            'Top Selling Products',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: analytics.topProducts.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: Text(
                        'No sales data yet. Start selling!',
                        style: TextStyle(color: Colors.grey),
                      ),
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
                            color: IcebergTheme.creamPink.withValues(
                              alpha: 0.5,
                            ),
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
                        title: Text(
                          p.productTitle,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('${p.quantitySold} sold'),
                        trailing: Text(
                          formatCurrency(p.revenue),
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
    BuildContext context,
    AnalyticsData analytics,
    bool isMobile,
  ) {
    final cards = [
      _StatInfo(
        "Today's Sales",
        formatCurrency(analytics.todaysSales),
        Icons.payments_outlined,
        IcebergTheme.vibrantRosePink,
      ),
      _StatInfo(
        'Total Orders',
        '${analytics.todaysOrderCount}',
        Icons.shopping_bag,
        const Color(0xFF4FC3F7),
      ),
      _StatInfo(
        'Avg Order',
        formatCurrency(analytics.averageOrderValue),
        Icons.trending_up,
        IcebergTheme.mintBlueDark,
      ),
      _StatInfo(
        'Top Product',
        analytics.topProduct,
        Icons.star,
        const Color(0xFFFFB74D),
      ),
    ];

    if (isMobile) {
      // Use adaptive aspect ratio based on screen width
      final screenWidth = MediaQuery.sizeOf(context).width;
      final aspectRatio = screenWidth <= 360 ? 1.0 : 1.2;

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: aspectRatio,
        children: cards.map((c) => _buildStatCard(c, isMobile: true)).toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildStatCard(c, isMobile: false),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStatCard(_StatInfo info, {required bool isMobile}) {
    final double padding = isMobile ? 14.0 : 20.0;
    final double iconSize = isMobile ? 20.0 : 24.0;
    final double iconPadding = isMobile ? 8.0 : 10.0;
    final double gap = isMobile ? 8.0 : 12.0;
    final double titleSize = isMobile ? 12.0 : 13.0;
    final double valueSize = isMobile ? 18.0 : 22.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(iconPadding),
              decoration: BoxDecoration(
                color: info.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(info.icon, color: info.color, size: iconSize),
            ),
            SizedBox(height: gap),
            Text(
              info.title,
              style: TextStyle(fontSize: titleSize, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  info.value,
                  style: TextStyle(
                    fontSize: valueSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
