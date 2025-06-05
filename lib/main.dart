import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/presentation/app/my_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MyMaterialApp();
  }
}
