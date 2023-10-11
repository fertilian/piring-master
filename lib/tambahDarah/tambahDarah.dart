import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InputDarah extends StatefulWidget {
  @override
  _InputDarahState createState() => _InputDarahState();
}

class _InputDarahState extends State<InputDarah> {
  // String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String clientId = "PKL2023";
  String clientSecret = "PKLSERU";
  String tokenUrl = "https://isipiringku.esolusindo.com/api/Token/token";
  String accessToken = "";

  Future<void> getToken() async {
    try {
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
        print('Gagal mendapatkan token: ${response.statusCode}');
      }
    } catch (e) {
      print('Gagal mendapatkan token: $e');
    }
  }

  // Simulated database (replace with your actual database implementation)
  // List<TambahDarah> _database = [];
  // String ID = '';

  // Future<void> loadUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userDataString = prefs.getString('user_data');

  //   if (userDataString != null) {
  //     final userData = UserData.fromJson(json.decode(userDataString));
  //     print(userData.nama);

  //     setState(() {
  //       ID = userData.idUser.toString();
  //     });
  //   }
  // }

  // Future<void> _saveDataToDatabase() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final userDataString = prefs.getString('user_data');

  //   if (userDataString != null) {
  //     print(userDataString);
  //     final userData = UserData.fromJson(json.decode(userDataString));
  //     print(userData.nama);

  //     setState(() {
  //       ID = userData.idUser.toString();
  //     });
  //   }
  //   print(ID);
  //   await getToken(); // Panggil getToken() untuk mendapatkan token akses

  //   final url = Uri.parse('https://isipiringku.esolusindo.com/api/Darah/darah');

  //   // Create a Map for the data to be sent
  //   final data = {
  //     "tanggal": currentDate,
  //     "id_user": ID,
  //     "status": 'sudah',
  //   };

  //   final response = await http.post(
  //     url,
  //     headers: {
  //       // 'Authorization': 'Bearer $accessToken',
  //     },
  //     body: data, // Konversi objek data ke dalam bentuk JSON
  //   );

  //   if (response.statusCode == 200) {
  //     // Data successfully sent to the server
  //     final record = TambahDarah(
  //       id_user: ID,
  //       tanggal: currentDate,
  //       status: 'sudah',
  //     );

  //     // In a real application, you would save the record to your database.
  //     // Here, we'll add it to a list for demonstration purposes.
  //     _database.add(record);

  //     // Navigate back to the previous screen (Dashboard in this case)
  //     Navigator.of(context).pop();
  //   } else {
  //     // Handle error here, e.g., show an error message to the user
  //     print('Error: ${response.statusCode}, ${response.body}');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 250, 154, 0),
                  Color.fromARGB(255, 246, 80, 20),
                  Color.fromARGB(255, 235, 38, 16),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.orange,
                              size: 25,
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Dashboard()));
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          child: Text(
                            'TAMBAH DARAH',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/calendar.png',
                                width: 30.0,
                                height: 30.0,
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                'Tambah Darah Hari Ini',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Tambahkan komponen UI lainnya di sini
                          SizedBox(
                            height:
                                20, // Tambahkan jarak antara teks dan Container
                          ),
                          Container(
                            width: 400, // Lebar container
                            padding:
                                EdgeInsets.all(16.0), // Padding pada Container
                            decoration: BoxDecoration(
                              color: Colors
                                  .white, // Warna latar belakang Container
                              borderRadius: BorderRadius.circular(
                                  10.0), // Radius sudut sebesar 10
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Warna shadow abu-abu
                                  spreadRadius:
                                      5, // Seberapa jauh shadow menyebar
                                  blurRadius: 7, // Tingkat keburaman shadow
                                  offset: Offset(0, 3), // Posisi shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanggal:',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Steven',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                Text(
                                  'Apakah anda sudah minum tablet tambah darah?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 70),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Aksi saat tombol "Sudah" ditekan
                                        // _saveDataToDatabase();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      child: Text('Sudah'),
                                    ),
                                    SizedBox(width: 30),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Aksi saat tombol "Belum" ditekan
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      child: Text('Belum'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
