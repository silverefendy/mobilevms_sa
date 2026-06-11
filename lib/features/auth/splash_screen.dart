import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_vms/core/auth/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final auth = context.read<AuthController>();
    await auth.restoreSession();
    
    if (!mounted) return;
    
    // Navigate based on auth status
    if (auth.status == AuthStatus.authenticated) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.domain_rounded, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'VMS',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.teal,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Visitor Management System',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
