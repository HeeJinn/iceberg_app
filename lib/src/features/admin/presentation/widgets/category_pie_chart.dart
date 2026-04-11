import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/iceberg_theme.dart';
import '../../../products/domain/product.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<ProductCategory, double> categoryRevenue;

  const CategoryPieChart({super.key, required this.categoryRevenue});

  static const _categoryColors = {
    ProductCategory.iceCream: IcebergTheme.vibrantRosePink,
    ProductCategory.vessel: IcebergTheme.mintBlueDark,
    ProductCategory.topping: Color(0xFFFFB74D),
    ProductCategory.drink: Color(0xFF4FC3F7),
    ProductCategory.other: Color(0xFFAED581),
  };

  static const _categoryLabels = {
    ProductCategory.iceCream: 'Ice Cream',
    ProductCategory.vessel: 'Vessels',
    ProductCategory.topping: 'Toppings',
    ProductCategory.drink: 'Drinks',
    ProductCategory.other: 'Other',
  };

  @override
  Widget build(BuildContext context) {
    final total = categoryRevenue.values.fold(0.0, (a, b) => a + b);
    final hasData = total > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Revenue by Category',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(hasData ? 'Today\'s breakdown' : 'No sales data yet',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: hasData
                  ? Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: categoryRevenue.entries.map((e) {
                                final pct = (e.value / total * 100);
                                return PieChartSectionData(
                                  color: _categoryColors[e.key] ??
                                      Colors.grey,
                                  value: e.value,
                                  title: '${pct.toStringAsFixed(0)}%',
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: categoryRevenue.entries.map((e) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: _categoryColors[e.key] ??
                                            Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _categoryLabels[e.key] ?? 'Other',
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline,
                              size: 48,
                              color: Colors.grey.shade300),
                          const SizedBox(height: 8),
                          Text('Make some sales to see data!',
                              style: TextStyle(color: Colors.grey.shade400)),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
