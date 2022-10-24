import 'package:flutter/material.dart';

import '../helper/app_config.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = AppConfig.homeRouteName;
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConfig.appTitle,
        ),
      ),
      body: Container(),
    );
  }
}
