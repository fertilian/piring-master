import 'dart:core';
import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';

class FormIMT extends StatefulWidget {
  const FormIMT({Key? key});

  @override
  State<FormIMT> createState() => _FormIMTState();
}

class _FormIMTState extends State<FormIMT> {
  final TextEditingController tinggiBadanController = TextEditingController();
  final TextEditingController beratBadanController = TextEditingController();
  final TextEditingController IMTController = TextEditingController();

  @override
  void dispose() {
    tinggiBadanController.dispose();
    beratBadanController.dispose();
    IMTController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(selected: 1),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/head2.jpg'),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(top: 64)),
                          SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.height * 0.4,
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 250, 154, 0),
                                    Color.fromARGB(255, 246, 80, 20),
                                    Color.fromARGB(255, 235, 38, 16),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: kElevationToShadow[1],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 0,
                              ),
                              child: Center(
                                child: Text(
                                  'Form IMT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lengkapi form berikut',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        'Tinggi Badan Anda',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 5.0, left: 28.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 219, 218, 218),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: SizedBox(
                                              width: 80.0,
                                              child: TextField(
                                                controller:
                                                    tinggiBadanController,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        'Berat Badan Anda',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 5.0, left: 30.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 219, 218, 218),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: SizedBox(
                                              width: 80.0,
                                              child: TextField(
                                                controller:
                                                    beratBadanController,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        'IMT ',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 5.0, left: 130.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 219, 218, 218),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            child: SizedBox(
                                              width: 80.0,
                                              child: TextField(
                                                controller: IMTController,
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50.0),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final double tinggi = double.tryParse(
                                                tinggiBadanController.text) ??
                                            0.0;
                                        final double berat = double.tryParse(
                                                beratBadanController.text) ??
                                            0.0;

                                        if (tinggi > 0 && berat > 0) {
                                          final double tinggiM = tinggi /
                                              100; // Ubah tinggi dari cm ke m
                                          final double imt =
                                              berat / (tinggiM * tinggiM);
                                          IMTController.text = imt.toStringAsFixed(
                                              2); // Tampilkan IMT dengan 2 desimal
                                        } else {
                                          IMTController.text = 'Invalid Input';
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.deepOrange,
                                      ),
                                      child: Text('Simpan'),
                                    ),
                                  ),
                                  SizedBox(height: 120.0), // Tambahkan spasi
                                  DataTable(
                                    columns: [
                                      DataColumn(label: Text('Klasifikasi')),
                                      DataColumn(label: Text('Keterangan')),
                                      DataColumn(label: Text('IMT')),
                                    ],
                                    decoration: BoxDecoration(
                                      color: Colors
                                          .yellow, // Ganti dengan warna hijau yang Anda inginkan
                                    ),
                                    rows: [
                                      DataRow(cells: [
                                        DataCell(Text('Kurus')),
                                        DataCell(Text('Berat\nRingan')),
                                        DataCell(Text('17.0 \n17.0-18.4')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Normal')),
                                        DataCell(Text('')),
                                        DataCell(Text('23 - 24.9')),
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Gemuk')),
                                        DataCell(Text('Ringan \n Berat')),
                                        DataCell(Text('25.1-27.0 \n >27')),
                                      ]),
                                      // Tambahkan baris klasifikasi IMT di sini
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
