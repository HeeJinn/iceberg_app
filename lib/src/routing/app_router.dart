import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:iceberg_app/src/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:iceberg_app/src/features/pos/presentation/pos_screen.dart';
import 'package:iceberg_app/src/features/pos/presentation/clock_out_screen.dart';
import 'package:iceberg_app/src/features/auth/application/auth_controller.dart';
import 'package:iceberg_app/src/features/auth/presentation/pin_login_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  
  return GoRouter(
    initialLocation: '/pos',
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoggingIn = state.matchedLocation == '/login';
      
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }
      
      if (isLoggedIn && isLoggingIn) {
        return '/pos';
      }
      
      // Guard admin route — only allow admin role
      if (state.matchedLocation == '/admin' && isLoggedIn && !authState.isAdmin) {
        return '/pos';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const PinLoginScreen(),
      ),
      GoRoute(
        path: '/pos',
        builder: (context, state) => const PosScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/clock-out',
        builder: (context, state) => const ClockOutScreen(),
      ),
    ],
  );
}
