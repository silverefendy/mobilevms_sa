import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_vms/core/auth/auth_controller.dart';
import 'package:mobile_vms/core/network/jwt_api_client.dart';
import 'package:mobile_vms/core/storage/secure_token_storage.dart';
import 'package:mobile_vms/data/repositories/approval_repository_impl.dart';
import 'package:mobile_vms/data/repositories/dashboard_repository_impl.dart';
import 'package:mobile_vms/data/repositories/jwt_auth_repository_impl.dart';
import 'package:mobile_vms/data/repositories/lookup_repository_impl.dart';
import 'package:mobile_vms/data/repositories/qr_operations_repository_impl.dart';
import 'package:mobile_vms/domain/repositories/approval_repository.dart';
import 'package:mobile_vms/domain/repositories/dashboard_repository.dart';
import 'package:mobile_vms/domain/repositories/lookup_repository.dart';
import 'package:mobile_vms/domain/repositories/qr_operations_repository.dart';
import 'package:mobile_vms/features/approvals/approvals_screen.dart';
import 'package:mobile_vms/features/auth/splash_screen.dart';
import 'package:mobile_vms/features/auth/login_screen.dart';
import 'package:mobile_vms/features/auth/server_setup_screen.dart';
import 'package:mobile_vms/features/dashboard/dashboard_screen.dart';
import 'package:mobile_vms/features/scanner/scanner_screen.dart';

class VMSApp extends StatelessWidget {
  const VMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize dependencies
    final storage = SecureTokenStorage();
    final apiClient = JwtApiClient(storage: storage);
    final authRepository = JwtAuthRepositoryImpl(
      dio: apiClient.dio,
      storage: storage,
    );
    final authController = AuthController(authRepository: authRepository);
    final qrRepository = QROperationsRepositoryImpl(apiClient);
    final approvalRepository = ApprovalRepositoryImpl(apiClient);
    final dashboardRepository = DashboardRepositoryImpl(apiClient);
    final lookupRepository = LookupRepositoryImpl(apiClient);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/setup',
          builder: (context, state) => const ServerSetupScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/scanner',
          builder: (context, state) => const ScannerScreen(),
        ),
        GoRoute(
          path: '/approvals',
          builder: (context, state) => const ApprovalsScreen(),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>.value(value: authController),
        Provider<JwtApiClient>.value(value: apiClient),
        Provider<QROperationsRepository>.value(value: qrRepository),
        Provider<ApprovalRepository>.value(value: approvalRepository),
        Provider<DashboardRepository>.value(value: dashboardRepository),
        Provider<LookupRepository>.value(value: lookupRepository),
      ],
      child: MaterialApp.router(
        title: 'VMS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
