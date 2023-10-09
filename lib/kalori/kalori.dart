import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';
import 'package:piring_baru/kalori/tambah.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Kalori extends StatefulWidget {
  const Kalori({super.key});

  @override
  State<Kalori> createState() => _KaloriState();
}

class _KaloriState extends State<Kalori> {
  double totalEnergi = 0.0;
  String formattedDate = DateFormat('dd-mm-yyyy').format(DateTime.now());
  String clientId = "PKL2023";
  String clientSecret = "PKLSERU";
  String tokenUrl =
      "https://apem.esolusindo.com/API/Token/token"; // Ganti dengan URL token endpoint Anda

  String accessToken = "";

  Future<void> getToken() async {
    try {
      // Buat permintaan untuk mendapatkan token menggunakan client_credentials
      var response = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'client_credentials',
          'client_id': clientId,
          'client_secret': clientSecret,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> tokenData = jsonDecode(response.body);
        accessToken = tokenData['access_token'];
        print('Token Akses: $accessToken');
      } else {
        // Handle error, misalnya, menampilkan pesan kesalahan
        print('Gagal mendapatkan token: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception, misalnya, menampilkan pesan kesalahan
      print('Gagal mendapatkan token: $e');
    }
  }

  List<dynamic> data = [];

  Future fetchData() async {
    final response = await http.get(
      Uri.parse(
        'https://isipiringku.esolusindo.com/api/Makanan/konsumsi?id_user=36&waktu=2023-10-4',
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        data = jsonResponse['response'];

        // Hitung total energi
        totalEnergi = data
            .map((item) => double.parse(item['energi']))
            .fold(0.0, (prev, curr) => prev + curr); // Change 0 to 0.0
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(selected: 1),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: 130,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/head2.jpg'),
                    fit: BoxFit.cover)),
          ),
          SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(top: 64)),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.height * 0.4,
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
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
                              child: const Center(
                                child: Text(
                                  'Kalori Harian',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.redAccent,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ]),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: const Text(
                                    'Budget Kalori Harian\n1800 Kkal',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 229, 222, 156),
                                      borderRadius: BorderRadius.circular(10)),
                                  child:
                                      // ignore: unnecessary_null_comparison
                                      totalEnergi == 0
                                          ? CircularProgressIndicator()
                                          : Text(
                                              "${totalEnergi.toInt()} Kkal",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 70, // Tinggi container
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Tambahkan kode navigasi ke halaman dashboard di sini
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const TambahKalori(); // Ganti dengan halaman dashboard yang sesuai
                                    }));
                                  },
                                  child: Card(
                                    elevation: 15, // Tingkat elevasi card
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom: 5,
                                          right:
                                              10.0), // Padding untuk konten card
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Gambar dari asset
                                          Container(
                                            width: 60.0, // Lebar gambar
                                            height: 60.0, // Tinggi gambar
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/morning.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          const Center(
                                            child: Text(
                                              'SARAPAN',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            child: Text(''),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 75, // Tinggi container
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Tambahkan kode navigasi ke halaman dashboard di sini
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const TambahKalori(); // Ganti dengan halaman dashboard yang sesuai
                                    }));
                                  },
                                  child: Card(
                                    elevation: 15, // Tingkat elevasi card
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom:
                                              10), // Padding untuk konten card
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Gambar dari asset
                                          Container(
                                            width: 60.0, // Lebar gambar
                                            height: 60.0, // Tinggi gambar
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/sun.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          const Center(
                                            child: Text(
                                              'MAKAN SIANG',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                          Container(
                                            child: Text(''),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 75, // Tinggi container
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Tambahkan kode navigasi ke halaman dashboard di sini
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const TambahKalori(); // Ganti dengan halaman dashboard yang sesuai
                                    }));
                                  },
                                  child: Card(
                                    elevation: 15, // Tingkat elevasi card
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom:
                                              10), // Padding untuk konten card
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Gambar dari asset
                                          Container(
                                            width: 60.0, // Lebar gambar
                                            height: 60.0, // Tinggi gambar
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/half-moon.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          const Center(
                                            child: Text(
                                              'MAKAN MALAM',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                          Container(
                                            child: Text(''),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            // Tinggi container
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Tambahkan kode navigasi ke halaman dashboard di sini
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const TambahKalori(); // Ganti dengan halaman dashboard yang sesuai
                                    }));
                                  },
                                  child: Card(
                                    elevation: 15, // Tingkat elevasi card
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          bottom:
                                              10), // Padding untuk konten card
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Gambar dari asset
                                          Container(
                                            width: 50.0, // Lebar gambar
                                            height: 50.0, // Tinggi gambar
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/fast-food.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          const Center(
                                            child: Text(
                                              'CAMILAN',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                          Container(
                                            child: Text(''),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
