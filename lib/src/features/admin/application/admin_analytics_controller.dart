import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iceberg_app/src/features/orders/data/order_repository.dart';
import 'package:iceberg_app/src/features/products/data/product_repository.dart';
import 'package:iceberg_app/src/features/products/domain/product.dart';

part 'admin_analytics_controller.g.dart';

class AnalyticsData {
  final double todaysSales;
  final int todaysOrderCount;
  final double averageOrderValue;
  final String topProduct;
  final List<DailySales> weeklyTrend;
  final Map<ProductCategory, double> categoryRevenue;
  final Map<int, int> hourlyOrders;
  final List<ProductSalesInfo> topProducts;

  AnalyticsData({
    required this.todaysSales,
    required this.todaysOrderCount,
    required this.averageOrderValue,
    required this.topProduct,
    required this.weeklyTrend,
    required this.categoryRevenue,
    required this.hourlyOrders,
    required this.topProducts,
  });
}

class DailySales {
  final DateTime date;
  final double total;
  final int orderCount;

  DailySales({required this.date, required this.total, required this.orderCount});
}

class ProductSalesInfo {
  final String productId;
  final String productTitle;
  final int quantitySold;
  final double revenue;

  ProductSalesInfo({
    required this.productId,
    required this.productTitle,
    required this.quantitySold,
    required this.revenue,
  });
}

@riverpod
AnalyticsData adminAnalytics(Ref ref) {
  final orders = ref.watch(orderRepositoryProvider);
  final products = ref.watch(productRepositoryProvider);

  // Today's data
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final todaysOrders = orders.where((o) => o.timestamp.isAfter(startOfToday)).toList();
  final todaysSales = todaysOrders.fold(0.0, (sum, o) => sum + o.totalPrice);
  final avgOrder = todaysOrders.isEmpty ? 0.0 : todaysSales / todaysOrders.length;

  // Weekly trend (last 7 days)
  final weeklyTrend = <DailySales>[];
  for (int i = 6; i >= 0; i--) {
    final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
    final nextDate = date.add(const Duration(days: 1));
    final dayOrders = orders.where((o) =>
      o.timestamp.isAfter(date) && o.timestamp.isBefore(nextDate)
    ).toList();
    weeklyTrend.add(DailySales(
      date: date,
      total: dayOrders.fold(0.0, (sum, o) => sum + o.totalPrice),
      orderCount: dayOrders.length,
    ));
  }

  // Category revenue
  final categoryRevenue = <ProductCategory, double>{};
  for (final order in todaysOrders) {
    for (final item in order.items) {
      try {
        final product = products.firstWhere((p) => p.id == item.productId);
        categoryRevenue[product.category] = 
          (categoryRevenue[product.category] ?? 0) + item.subtotal;
      } catch (_) {}
    }
  }

  // Hourly orders
  final hourlyOrders = <int, int>{};
  for (final order in todaysOrders) {
    final hour = order.timestamp.hour;
    hourlyOrders[hour] = (hourlyOrders[hour] ?? 0) + 1;
  }

  // Top products
  final productSales = <String, ProductSalesInfo>{};
  for (final order in orders) {
    for (final item in order.items) {
      try {
        final product = products.firstWhere((p) => p.id == item.productId);
        if (productSales.containsKey(item.productId)) {
          final existing = productSales[item.productId]!;
          productSales[item.productId] = ProductSalesInfo(
            productId: item.productId,
            productTitle: product.title,
            quantitySold: existing.quantitySold + item.quantity,
            revenue: existing.revenue + item.subtotal,
          );
        } else {
          productSales[item.productId] = ProductSalesInfo(
            productId: item.productId,
            productTitle: product.title,
            quantitySold: item.quantity,
            revenue: item.subtotal,
          );
        }
      } catch (_) {}
    }
  }

  final topProductsList = productSales.values.toList()
    ..sort((a, b) => b.revenue.compareTo(a.revenue));

  final topProduct = topProductsList.isNotEmpty ? topProductsList.first.productTitle : 'N/A';

  return AnalyticsData(
    todaysSales: todaysSales,
    todaysOrderCount: todaysOrders.length,
    averageOrderValue: avgOrder,
    topProduct: topProduct,
    weeklyTrend: weeklyTrend,
    categoryRevenue: categoryRevenue,
    hourlyOrders: hourlyOrders,
    topProducts: topProductsList.take(5).toList(),
  );
}
