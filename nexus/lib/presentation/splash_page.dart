import 'package:flutter/material.dart';
import 'package:nexus/core/info/app_info.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(AppInfo.appName),
      ),
    );
  }
}