import 'package:flutter/material.dart';

void main() {
  runApp(TabInputDarah());
}

class TabInputDarah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Input Darah'),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: [
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Apakah anda sudah meminum tablet tambah darah hari ini?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: 20.0), // Tambahkan jarak antara teks dan card
            Card(
              elevation: 3.0,
              shadowColor: Colors.grey, // Warna bayangan
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Info Tablet Tambah Darah",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Tindakan yang ingin Anda lakukan ketika tombol "Ya" ditekan
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                          ),
                          child: Text("Ya"),
                        ),
                        SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: () {
                            // Tindakan yang ingin Anda lakukan ketika tombol "Tidak" ditekan
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: Text("Tidak"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
