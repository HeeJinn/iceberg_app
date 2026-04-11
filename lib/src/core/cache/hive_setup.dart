import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:iceberg_app/hive_registrar.g.dart';
import 'package:iceberg_app/src/features/products/domain/product.dart';
import 'package:iceberg_app/src/features/orders/domain/order.dart';
import 'package:iceberg_app/src/features/reports/domain/shift_report.dart';
import 'package:iceberg_app/src/features/auth/domain/staff_member.dart';

Future<void> setupHive() async {
  await Hive.initFlutter();
  
  // Register adapters that will be generated via build_runner
  // hive_registrar.g.dart contains hivece register logic
  Hive.registerAdapters();

  // Open boxes
  await Hive.openBox<Product>('products');
  await Hive.openBox<Order>('orders');
  await Hive.openBox<ShiftReport>('shift_reports');
  await Hive.openBox<StaffMember>('staff');
  await Hive.openBox<String>('sync_queue');
  await Hive.openBox<String>('categories');
  await Hive.openBox('settings');
}
