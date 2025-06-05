import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/router/router.dart';

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Absence Manager',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
