import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pause/screens/home.dart';
import 'package:pause/screens/login.dart';

import 'helper/app_config.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  runApp(
    const MyApp(),
  );
}

// FlutterNativeSplash.remove();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: AppConfig.primaryColor,
            ),
      ),
      home: const LoginScreen(),
      routes: {
        MyHomePage.routeName: (_) => const MyHomePage(),
        LoginScreen.routeName: (_) => const LoginScreen(),
      },
    );
  }
}
