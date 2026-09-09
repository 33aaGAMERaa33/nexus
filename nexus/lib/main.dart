import 'package:flutter/material.dart';
import 'package:nexus/presentation/initialization_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: .dark,
      darkTheme: .dark(),
      navigatorKey: navigatorKey,
      home: const InitializationPage(),
    );
  }
}