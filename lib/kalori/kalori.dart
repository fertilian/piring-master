import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';
import 'package:piring_baru/kalori/tambah.dart';
import 'package:http/http.dart' as http;

class Kalori extends StatefulWidget {
  const Kalori({super.key});

  @override
  State<Kalori> createState() => _KaloriState();
}

class _KaloriState extends State<Kalori> {
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

  Future<void> fetchRiwayatHariIni() async {
    try {
      var response = await http.get(
        Uri.parse(
            'https://isipiringku.esolusindo.com/api/Makanan/konsumsi?id_user=36&waktu=2023-10-4'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['response'] as List<dynamic>;
        final List<Map<String, dynamic>> riwayatData =
            data.cast<Map<String, dynamic>>();

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Riwayat Hari Ini'),
              content: SingleChildScrollView(
                child: Column(
                  children: riwayatData.map((item) {
                    return ListTile(
                      title: Text(item['nama_makanan']),
                      subtitle: Text('Besaran: ${item['besaran']}'),
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Tutup'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Gagal mengambil data riwayat: ${response.statusCode}');
      }
    } catch (e) {
      print('Gagal mengambil data riwayat: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(selected: 1),
      body: SingleChildScrollView(
        child: Stack(children: [
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
                                  'Kalori Harian',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Row(children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.redAccent,
                                size: 30,
                              ),
                              SizedBox(
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
                                  '04-06-2023',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ]),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
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
                                      color: Color.fromARGB(255, 229, 222, 156),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "1191 Kkal",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
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
                                      return TambahKalori(); // Ganti dengan halaman dashboard yang sesuai
                                    }));
                                  },
                                  child: Card(
                                    elevation: 15, // Tingkat elevasi card
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Padding(
                                      padding: EdgeInsets.only(
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
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/morning.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          Center(
                                            child: Text(
                                              'SARAPAN',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),

                                          Container(
                                            child: Icon(
                                              Icons.plus_one,
                                              color: Colors.orange,
                                              size: 25,
                                            ),
                                          ),
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
                                // Card pertama
                                Card(
                                  elevation: 15, // Tingkat elevasi card
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Padding(
                                    padding: EdgeInsets.only(
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
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/sun.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        Center(
                                          child: Text(
                                            'MAKAN SIANG',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        Container(
                                          child: Icon(
                                            Icons.plus_one,
                                            color: Colors.orange,
                                            size: 25,
                                          ),
                                        ),
                                      ],
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
                                // Card pertama
                                Card(
                                  elevation: 15, // Tingkat elevasi card
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Padding(
                                    padding: EdgeInsets.only(
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
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/half-moon.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        Center(
                                          child: Text(
                                            'MAKAN MALAM',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        Container(
                                          child: Icon(
                                            Icons.plus_one,
                                            color: Colors.orange,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // Tinggi container
                            child: Column(
                              children: [
                                // Card pertama
                                Card(
                                  elevation: 15, // Tingkat elevasi card
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Padding(
                                    padding: EdgeInsets.only(
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
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/fast-food.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        Center(
                                          child: Text(
                                            'CAMILAN',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        Container(
                                          child: Icon(
                                            Icons.plus_one,
                                            color: Colors.orange,
                                            size: 25,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 70),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      fetchRiwayatHariIni();
                                    },
                                    child: Text('Riwayat Hari Ini'),
                                  ),
                                ),
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
