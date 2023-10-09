import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';
import 'package:piring_baru/kalori/kalori.dart';
import 'package:piring_baru/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TambahKalori extends StatefulWidget {
  const TambahKalori({
    super.key,
  });

  @override
  State<TambahKalori> createState() => _TambahKaloriState();
}

class _TambahKaloriState extends State<TambahKalori> {
  List<int> cardValues = [];
  List<Map<String, dynamic>> selectedFoods = [];

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFoodData = [];
  String clientId = "PKL2023";
  String clientSecret = "PKLSERU";
  String tokenUrl = "https://isipiringku.esolusindo.com/api/Token/token";
  String apiUrl = "https://isipiringku.esolusindo.com/api/Konsumsi/Konsumsi";
  String accessToken = "";
  List<Map<String, dynamic>> foodData = [];
  bool isSearching = false;
  int cardValue = 0;
  String Id = '';

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      final userData = UserData.fromJson(json.decode(userDataString));
      print(userData.nama);

      setState(() {
        Id = userData.idUser.toString();
      });
    }
  }

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
    loadUserData();
    getToken().then((_) {
      fetchData().then((data) {
        setState(() {
          foodData = data;
          filteredFoodData = data; // Menginisialisasi dengan data asli

          // Inisialisasi cardValues dengan panjang yang sesuai
          cardValues = List.filled(foodData.length, 0);
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

  Future<void> kirimData(String idMakanan, int index) async {
    try {
      var energi = foodData[index]['energi'].toString();
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_user': Id,
          'total_kalori': energi,
          'keterangan': 'sarapan',
          'bahan_makanan_nama_makanan': idMakanan,
        }),
      );

      if (response.statusCode == 200) {
        print('Data berhasil dikirim');
        print(response.body);

        setState(() {
          cardValues[index] += 1;
        });

        var selectedFood = selectedFoods.firstWhereOrNull(
          (food) => food['id_makanan'] == idMakanan,
        );

        if (selectedFood == null) {
          // Jika makanan belum ada di dalam selectedFoods, tambahkan makanan tersebut
          selectedFoods.add({
            ...foodData[index],
            'jumlahDipilih': 1,
          });
        } else {
          // Jika makanan sudah ada di dalam selectedFoods, tambahkan 1 ke properti jumlahDipilih
          selectedFood['jumlahDipilih'] += 1;
        }

        Fluttertoast.showToast(
          msg: 'Berhasil Kirim Data',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
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
                            height: 200,
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
                                    kirimData(foodItem['id_makanan'], index);
                                  },
                                  child: Card(
                                    child: GestureDetector(
                                      onTap: () {
                                        kirimData(
                                            foodItem['id_makanan'], index);
                                      },
                                      child: ListTile(
                                        title: Text(foodItem['nama_makanan']),
                                        subtitle: Text(
                                            'Energi: ${foodItem['energi']}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                '${cardValues[index]}'), // Menampilkan angka di sebelah kanan card
                                            Icon(Icons.arrow_forward_ios),
                                          ],
                                        ),
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
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Makanan yang Dipilih',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: selectedFoods.length,
                            itemBuilder: (context, index) {
                              final selectedFood = selectedFoods[index];
                              final namaMakanan = selectedFood['nama_makanan'];

                              // Mengambil energi dari selectedFood sebagai String
                              final energiString = selectedFood['energi'];

                              // Mengonversi energiString ke tipe data int jika angka yang valid
                              final energi =
                                  double.tryParse(energiString) ?? 0.0;

                              final jumlahDipilih =
                                  selectedFood['jumlahDipilih'] as int;

                              // Melakukan perhitungan energi * jumlahDipilih
                              final totalEnergi = energi * jumlahDipilih;
                              print('energiString: $energiString');
                              print('jumlahDipilih: $jumlahDipilih');
                              print('totalEnergi: $totalEnergi');

                              return Card(
                                child: ListTile(
                                  title: Text('$namaMakanan (x$jumlahDipilih)'),
                                  subtitle: Text(
                                      'Total Energi: $totalEnergi'), // Menampilkan total energi
                                ),
                              );
                            },
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
