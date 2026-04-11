import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../application/admin_analytics_controller.dart';

class SalesLineChart extends StatelessWidget {
  final List<DailySales> weeklyTrend;

  const SalesLineChart({super.key, required this.weeklyTrend});

  @override
  Widget build(BuildContext context) {
    final rawMax = weeklyTrend.isEmpty
        ? 100.0
        : weeklyTrend.map((e) => e.total).reduce((a, b) => a > b ? a : b) * 1.3;
    final maxY = rawMax < 1 ? 100.0 : rawMax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly Sales Trend',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Last 7 days performance',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 4 < 1 ? 1 : maxY / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade600));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < weeklyTrend.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('E').format(weeklyTrend[index].date),
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey.shade600),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: weeklyTrend.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.total);
                      }).toList(),
                      isCurved: true,
                      color: IcebergTheme.vibrantRosePink,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: IcebergTheme.white,
                          strokeWidth: 2,
                          strokeColor: IcebergTheme.vibrantRosePink,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            IcebergTheme.vibrantRosePink.withValues(alpha: 0.3),
                            IcebergTheme.vibrantRosePink.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (spots) {
                        return spots.map((spot) {
                          return LineTooltipItem(
                            '\$${spot.y.toStringAsFixed(2)}',
                            const TextStyle(
                              color: IcebergTheme.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
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
