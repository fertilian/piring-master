import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';

class Notifikasi extends StatelessWidget {
  const Notifikasi({Key? key});

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
                                  'Notifikasi',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Tambahkan jarak di sini
                          SizedBox(
                              height:
                                  20), // Sesuaikan tinggi jarak sesuai kebutuhan
                          Center(
                            child: Container(
                              width: 380,
                              height: 100,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.deepOrange, // Warna border
                                  width: 2.0, // Lebar border
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tambahkan gambar dari assets di sini
                                  Image.asset(
                                    'assets/images/shusi.webp',
                                    width:
                                        80, // Sesuaikan dengan ukuran gambar Anda
                                    height:
                                        80, // Sesuaikan dengan ukuran gambar Anda
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Anda belum menambahkan \n sarapan hari ini',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '30 menit yang lalu',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  5.0), // Sesuaikan tinggi jarak sesuai kebutuhan
                          Center(
                            child: Container(
                              width: 380,
                              height: 100,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 103, 92),
                                border: Border.all(
                                  color: Colors.white, // Warna border
                                  width: 2.0, // Lebar border
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Tambahkan gambar dari assets di sini
                                  Image.asset(
                                    'assets/images/shusi.webp',
                                    width:
                                        80, // Sesuaikan dengan ukuran gambar Anda
                                    height:
                                        80, // Sesuaikan dengan ukuran gambar Anda
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Anda belum melakukan \n tambah darah hari ini',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '30 menit yang lalu',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
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
