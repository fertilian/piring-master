import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:page_transition/page_transition.dart';
import 'package:piring_baru/Login/components/login_form.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';
import 'package:piring_baru/kalori/testingTotalKalori.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:piring_baru/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> data = [];
  String Nama = '';
  String Email = '';

  String TB = '';
  String BB = '';
  String Id = '';
  String umur = '';
  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://isipiringku.esolusindo.com/api/Gambar/getgambar'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body)['response'];
      });
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null) {
      final userData = UserData.fromJson(json.decode(userDataString));
      print(userData.nama);

      setState(() {
        Nama = userData.nama;
        Email = userData.email;
        TB = userData.tinggiBadan;
        BB = userData.beratBadan;
        Id = userData.idUser.toString();
        umur = userData.umur;
      });
    }
  }

  Future<void> logoutUser() async {
    // Hapus token akses dari Shared Preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token');
    prefs.remove('user_data'); // Jika ada data pengguna lain yang perlu dihapus

    // Arahkan pengguna kembali ke halaman login
    Navigator.of(context).pushAndRemoveUntil(
      PageTransition(
        child: LoginForm(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 500),
      ),
      (route) => false, // Hapus seluruh riwayat navigasi
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(selected: 0),
      appBar: AppBar(
        toolbarHeight: 20,
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 24),
                      child: Text(
                        'Hi, ' + Nama + Id,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 24),
                      child: Transform.scale(
                        scale: 1.5,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 25,
                  ),
                  child: Container(
                    height: 120,
                    width: 360,
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => InputBB(),
                        //   ),
                        // );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Umur',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                umur + ' Tahun',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 1.0,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tinggi\nBadan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                TB + 'cm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 1.0,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Berat\nBadan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                BB + 'kg',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.white,
                            thickness: 1.0,
                            indent: 10.0,
                            endIndent: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'IMT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                '18.7',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
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

          // jangan di utak atik .. F
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 20,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 132, 165, 192)),
            child: Marquee(
              text:
                  'Jaga Kesehatan Anda Dengan Menjaga Pola Makan Dan Olah Raga Yang Cukup',
              style: TextStyle(fontSize: 16),

              scrollAxis: Axis.horizontal, // Arah pergerakan teks (horizontal)
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 300, // Jarak antara teks yang berulang
              velocity: 30, // Kecepatan bergeraknya teks
              pauseAfterRound:
                  Duration(seconds: 1), // Jeda setelah satu putaran
              showFadingOnlyWhenScrolling: false,
              fadingEdgeStartFraction: 0.1,
              fadingEdgeEndFraction: 0.1,
              startPadding: 10, // Padding awal sebelum teks bergerak
              accelerationDuration: Duration(seconds: 1), // Durasi percepatan
              accelerationCurve: Curves.linear, // Kurva percepatan
              decelerationDuration:
                  Duration(milliseconds: 500), // Durasi perlambatan
              decelerationCurve: Curves.easeOut, // Kurva perlambatan
            ),
          ),

          // marquee

          SizedBox(
            height: 10,
          ),
          Container(
            height: 130,
            child: ListView.builder(
              itemExtent: 250,
              itemCount: data.length, // Jumlah card yang ingin ditampilkan
              scrollDirection:
                  Axis.horizontal, // Untuk menggeser card ke samping
              itemBuilder: (BuildContext context, int index) {
                // Daftar warna gradient yang berbeda
                List<List<Color>> gradients = [
                  [Colors.blue, Colors.white],
                  [Colors.green, Colors.white],
                  [Colors.red, Colors.white],
                  [Colors.orange, Colors.white],
                  [Colors.purple, Colors.white],
                ];

                return Padding(
                  padding: EdgeInsets.all(10.0), // Spasi antar card
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    width: 250, // Lebar card
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: gradients[index],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Gambar dari asset
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  data[index][
                                      'judul_artikel'], // Ganti dengan deskripsi yang sesuai
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Warna teks pada latar belakang gradient
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Tambahkan widget lainnya di sini jika diperlukan
                            ],
                          ),
                        ),
                        SizedBox(width: 10), // Spasi antara gambar dan judul
                        Container(
                          width: 90, // Lebar gambar
                          height: 90, // Tinggi gambar
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              data[index]['url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Container(
          //   height: 130,
          //   child: ListView.builder(
          //     itemExtent: 250,
          //     itemCount: data.length,
          //     scrollDirection: Axis.horizontal,
          //     itemBuilder: (context, index) {
          //       // Generate a random color for the gradient
          //       final Color randomColor =
          //           Color(0xFF000000 + Random().nextInt(0xFFFFFF));

          //       return Card(
          //         child: Container(
          //           height: 150,
          //           width: 150,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(
          //                 30.0), // Tambahkan BorderRadius di sini
          //             gradient: LinearGradient(
          //               begin: Alignment.topLeft,
          //               end: Alignment.bottomRight,
          //               colors: [
          //                 Colors.white,
          //                 randomColor,
          //               ],
          //             ),
          //           ),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Padding(padding: EdgeInsets.only(left: 10, right: 10)),
          //               // Text(data[index]['judul_artikel']),
          //               Container(
          //                 child: Text(
          //                   data[index][
          //                       'judul_artikel'], // Ganti dengan deskripsi yang sesuai
          //                   style: TextStyle(
          //                     color: Colors
          //                         .white, // Warna teks pada latar belakang gradient
          //                     fontSize: 16.0,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(
          //                 width: 30,
          //               ),
          //               ClipRRect(
          //                 borderRadius: BorderRadius.circular(20),
          //                 child: Image.network(
          //                   data[index]['url'],
          //                   width: 90, // Ubah sesuai dengan kebutuhan
          //                   height: 90,
          //                   fit: BoxFit.cover,
          //                 ),
          //               )
          //               // Container(

          //               //   decoration: BoxDecoration(
          //               //       borderRadius: BorderRadius.circular(20)),
          //               //   child: Image.network(

          //               //     data[index]['url'],
          //               //     height: 140,
          //               //     width: 140,
          //               //   ),
          //               // ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          SizedBox(height: 20),

          Container(
              padding: (EdgeInsets.only(left: 40)),
              child: Text(
                'Informasi Gizi Kesehatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),

          // Informasi Gizi & Kesehatan (5 CardViews)
          Container(
            height: 280, // Tinggi container
            child: Column(
              children: [
                buildCard('Deskripsi Card 0', 130),
                SizedBox(
                  height: 15,
                ),
                buildCard('Deskripsi Card 1', 130),
                SizedBox(
                  height: 15,
                ),
                buildCard('Deskripsi Card 2', 130),
                // Tambahkan card lainnya di sini sesuai kebutuhan
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),

          Container(
              padding: (EdgeInsets.only(left: 40)),
              child: Text(
                'Pusat Informasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),

          Container(
            height: 100, // Tinggi container
            child: Column(
              children: [
                // Card pertama
                Card(
                  elevation: 3, // Tingkat elevasi card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Padding(
                    padding: EdgeInsets.all(15.0), // Padding untuk konten card
                    child: Row(
                      children: [
                        // Gambar dari asset
                        Container(
                          width: 50.0, // Lebar gambar
                          height: 50.0, // Tinggi gambar
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: AssetImage('assets/images/shusi.webp'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        Center(
                            child: Text(
                          'Memiliki Pertanyaa Seputar \n Isi Piringku?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))
                      ],
                    ),
                  ),
                ),
                // Card kedua (Salin dan sesuaikan elemen di atas untuk card selanjutnya)

                // Card ketiga (Salin dan sesuaikan elemen di atas untuk card selanjutnya)
              ],
            ),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestingTotal(),
                      ));
                },
                child: Text('testing')),
          )

          // Gunakan ListView.builder untuk membuat daftar informasi gizi & kesehatan
        ],
      ),
    );
  }

  Widget buildCard(String description, int calories) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: AssetImage('assets/images/shusi.webp'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text('irisan susi mantap')
                ],
              ),
            ),
            SizedBox(width: 30),
            Column(
              children: [
                Center(child: Text(' 130 \nkalori')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
