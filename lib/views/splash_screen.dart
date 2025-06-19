import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsnime/routes/route_name.dart';
import 'utils/helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.goNamed(RouteNames.introduction);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: Center(
        child: Image.asset('assets/images/logo.png', width: 123),
      ),
    );
  }
}