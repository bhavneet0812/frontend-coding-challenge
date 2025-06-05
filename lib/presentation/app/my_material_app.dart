import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/presentation/pages/absence_list_page/absence_list_page.dart';

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absence Manager',
      home: AbsenceListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
