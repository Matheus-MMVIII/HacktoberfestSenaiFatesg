import 'package:flutter/material.dart';
import 'package:agroapp/widgets/main_navigation.dart';

void main() {
  runApp(const MonitoramentoApp());
}

class MonitoramentoApp extends StatelessWidget {
  const MonitoramentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monitoramento Hídrico',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF087E8B)),
      ),
      home: const MainNavigation(),
    );
  }
}
