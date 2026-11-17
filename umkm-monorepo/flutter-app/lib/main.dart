import 'package:flutter/material.dart';

import 'screens/umkm_list_page.dart';

void main() => runApp(const UmkmApp());

class UmkmApp extends StatelessWidget {
  const UmkmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Direktori UMKM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1B6B5A),
      ),
      home: const UmkmListPage(),
    );
  }
}
