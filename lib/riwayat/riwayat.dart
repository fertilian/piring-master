import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:piring_baru/bloc/nav/bottom_nav.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:piring_baru/model/makanan.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({super.key});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<dynamic> makananList = [];
  Map<String, double> totalCaloriesByDate = {};

  DateTime startDate =
      DateTime.now().subtract(const Duration(days: 7)); // 7 hari terakhir
  DateTime endDate = DateTime.now();

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
      fetchData();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      fetchData();
    }
  }

  Future<void> fetchData() async {
    final Uri uri = Uri.parse(
        'https://isipiringku.esolusindo.com/api/Makanan/allKonsumsi?id_user=36');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final responseList = jsonData['response'];

      setState(() {
        makananList =
            responseList.map((item) => Makanan.fromJson(item)).toList();

        // Filter data makanan berdasarkan rentang waktu
        makananList = makananList.where((makanan) {
          final makananDate = makanan.waktu.toLocal();
          return makananDate
                  .isAfter(startDate.subtract(const Duration(days: 1))) &&
              makananDate.isBefore(endDate.add(const Duration(days: 1)));
        }).toList();

        // Kelompokkan data dan hitung total kalori per tanggal
        totalCaloriesByDate.clear(); // Bersihkan totalCaloriesByDate
        makananList.forEach((makanan) {
          String dateKey = makanan.waktu.toLocal().toString().split(' ')[0];
          if (totalCaloriesByDate.containsKey(dateKey)) {
            totalCaloriesByDate[dateKey] ??= 0.0;
            totalCaloriesByDate[dateKey] =
                totalCaloriesByDate[dateKey]! + makanan.energi!;
          } else {
            totalCaloriesByDate[dateKey] = makanan.energi;
          }
        });
      });
    } else {
      print(response.body);
    }
  }

  double _getMaxCaloriesValue() {
    double maxValue = 0;
    totalCaloriesByDate.values.forEach((calories) {
      if (calories > maxValue) {
        maxValue = calories;
      }
    });
    return maxValue;
  }

  List<FlSpot> _getChartData() {
    final List<FlSpot> spots = [];
    int index = 0;

    totalCaloriesByDate.forEach((date, calories) {
      spots.add(FlSpot(index.toDouble(), calories));
      index++;
    });

    return spots;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(selected: 2),
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
                                  'Riwayat',
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
                            height: 300,
                            width: double.infinity,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: true),

                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 700,
                                    ),
                                    axisNameSize: 10,
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: const Color(0xff37434d), width: 1),
                                ),
                                minX: 0,
                                maxX: totalCaloriesByDate.length.toDouble() - 1,
                                minY: 0,
                                maxY:
                                    _getMaxCaloriesValue(), // Tentukan nilai maksimum di sini
                                lineBarsData: [
                                  LineChartBarData(
                                    spots:
                                        _getChartData(), // Buat data grafik di sini
                                    isCurved: true,
                                    color: const Color(0xff4af699),
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 400,
                            width: double.infinity,
                            child: ListView.separated(
                              itemCount: totalCaloriesByDate
                                  .length, // Jumlah item adalah jumlah tanggal unik
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
                              itemBuilder: (BuildContext context, int index) {
                                String dateKey =
                                    totalCaloriesByDate.keys.elementAt(index);
                                double? totalCaloriesForDate =
                                    totalCaloriesByDate[dateKey];

                                return ListTile(
                                  title: Text("Tanggal: $dateKey"),
                                  subtitle: Text(
                                      "Total Kalori: $totalCaloriesForDate"),
                                );
                              },
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      "Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}"),
                                  ElevatedButton(
                                    onPressed: () => _selectStartDate(context),
                                    child: const Text("Select Start Date"),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      "End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}"),
                                  ElevatedButton(
                                    onPressed: () => _selectEndDate(context),
                                    child: const Text("Select End Date"),
                                  ),
                                ],
                              ),
                            ],
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
