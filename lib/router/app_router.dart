import 'package:go_router/go_router.dart';
import '../features/valves/valves_screen.dart';
import '../features/dashboard/dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),

    GoRoute(
  path: '/valves',

  builder: (context, state) =>
      const ValvesScreen(),
),
  ],
);