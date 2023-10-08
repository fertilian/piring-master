import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';
import 'package:piring_baru/kalori/kalori.dart';

class TambahKalori extends StatefulWidget {
  const TambahKalori({super.key});

  @override
  State<TambahKalori> createState() => _TambahKaloriState();
}

class _TambahKaloriState extends State<TambahKalori> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFoodData = [];
  String clientId = "PKL2023";
  String clientSecret = "PKLSERU";
  String tokenUrl = "https://isipiringku.esolusindo.com/api/Token/token";
  String apiUrl = "https://isipiringku.esolusindo.com/api/Konsumsi/Konsumsi";
  String accessToken = "";
  List<Map<String, dynamic>> foodData = [];
  bool isSearching = false;

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

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(
      Uri.parse('https://isipiringku.esolusindo.com/api/Makanan/makanan'),
      headers: {
        'Authorization':
            'Bearer $accessToken', // Use the access token obtained from getToken()
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['response'];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getToken().then((_) {
      fetchData().then((data) {
        setState(() {
          foodData = data;
          filteredFoodData = data; // Menginisialisasi dengan data asli
        });
      });
    });
  }

  void filterFoodList(String query) {
    setState(() {
      if (query.isNotEmpty) {
        isSearching = true;
        filteredFoodData = foodData.where((foodItem) {
          final namaMakanan = foodItem['nama_makanan'].toString().toLowerCase();
          return namaMakanan.contains(query.toLowerCase());
        }).toList();
      } else {
        isSearching = false;
        filteredFoodData = foodData;
      }
    });
  }

  Future<void> kirimData(String idMakanan) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_user': '36',
          'total_kalori': '200',
          'keterangan': 'sarapan',
          'bahan_makanan_nama_makanan':
              idMakanan, // Menggunakan ID makanan yang dipilih
        }),
      );

      if (response.statusCode == 200) {
        print('Data berhasil dikirim');
        print(response.body);
        Fluttertoast.showToast(
          msg: 'Berhasil Kirim Data',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Kalori(),
            ));
      } else {
        print('Gagal mengirim data: ${response.statusCode}');
      }
    } catch (e) {
      print('Gagal mengirim data: $e');
    }
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
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Makan Apa Hari Ini?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: TextFormField(
                              controller:
                                  searchController, // Menggunakan TextEditingController
                              onChanged: (query) {
                                filterFoodList(
                                    query); // Panggil fungsi filterFoodList saat teks berubah
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(Icons.search),
                                hintText: "Cari makanan",
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 340,
                            child: ListView.builder(
                              itemCount: isSearching
                                  ? filteredFoodData.length
                                  : foodData.length,
                              itemBuilder: (context, index) {
                                final foodItem = isSearching
                                    ? filteredFoodData[index]
                                    : foodData[index];
                                return GestureDetector(
                                  onTap: () {
                                    // Memanggil kirimData dengan id_makanan sebagai id_user
                                    kirimData(foodItem['id_makanan']);
                                  },
                                  child: Card(
                                    child: GestureDetector(
                                      onTap: () {
                                        kirimData(foodItem['id_makanan']);
                                      },
                                      child: ListTile(
                                        title: Text(foodItem['nama_makanan']),
                                        subtitle: Text(
                                            'Energi: ${foodItem['kategori']}'),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Divider(
                            thickness: 5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize:
                                        MaterialStatePropertyAll(Size(200, 30)),
                                    shape: MaterialStatePropertyAll(
                                        ContinuousRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)))),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Kalori(),
                                      ));
                                },
                                child: Text('Simpan')),
                          )
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
