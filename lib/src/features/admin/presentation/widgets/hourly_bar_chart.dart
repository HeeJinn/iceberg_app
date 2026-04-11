import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/iceberg_theme.dart';

class HourlyBarChart extends StatelessWidget {
  final Map<int, int> hourlyOrders;

  const HourlyBarChart({super.key, required this.hourlyOrders});

  @override
  Widget build(BuildContext context) {
    final rawMax = hourlyOrders.isEmpty
        ? 10.0
        : hourlyOrders.values.reduce((a, b) => a > b ? a : b).toDouble() * 1.3;
    final maxY = rawMax < 1 ? 10.0 : rawMax;

    // Only show hours 8am-10pm for relevance
    final relevantHours = List.generate(15, (i) => i + 8); // 8 to 22

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Orders by Hour', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Today\'s distribution',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final hour = relevantHours[group.x.toInt()];
                        final suffix = hour >= 12 ? 'PM' : 'AM';
                        final h12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
                        return BarTooltipItem(
                          '$h12$suffix: ${rod.toY.toInt()} orders',
                          const TextStyle(
                            color: IcebergTheme.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}',
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
                          if (index >= 0 && index < relevantHours.length) {
                            final hour = relevantHours[index];
                            final suffix = hour >= 12 ? 'p' : 'a';
                            final h12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
                            // Show every other label to avoid overlap
                            if (index % 2 == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text('$h12$suffix',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxY / 4 < 1 ? 1 : maxY / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  barGroups: relevantHours.asMap().entries.map((e) {
                    final count = hourlyOrders[e.value] ?? 0;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: count.toDouble(),
                          color: count > 0
                              ? IcebergTheme.vibrantRosePink
                              : Colors.grey.shade200,
                          width: 12,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
