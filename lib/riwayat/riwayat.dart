import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({super.key});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomNavBar(selected: 2),
      body: Text('riwayat'),
    );
  }
}
