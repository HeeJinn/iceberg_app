import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/cache/hive_setup.dart';
import 'src/routing/app_router.dart';
import 'src/core/theme/iceberg_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive CE
  await setupHive();

  runApp(const ProviderScope(child: IcebergApp()));
}

class IcebergApp extends ConsumerWidget {
  const IcebergApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Iceberg POS',
      theme: IcebergTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
