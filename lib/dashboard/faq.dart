import 'package:flutter/material.dart';

void main() {
  runApp(FAQPage());
}

class FAQPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'Apa itu Aplikasi Kalori?',
      answer:
          'Aplikasi Kalori adalah sebuah aplikasi yang dirancang untuk membantu pengguna menghitung dan memantau asupan kalori harian mereka. Aplikasi ini membantu pengguna menjaga pola makan sehat dan mengelola berat badan.',
    ),
    FAQItem(
      question: 'Bagaimana cara menggunakan Aplikasi Kalori?',
      answer:
          'Untuk menggunakan Aplikasi Kalori, pertama-tama Anda perlu membuat akun. Setelah masuk, Anda dapat mulai mencatat makanan yang Anda konsumsi setiap hari beserta jumlahnya. Aplikasi akan menghitung total kalori harian Anda berdasarkan data yang Anda masukkan.',
    ),
    FAQItem(
      question:
          'Apakah Aplikasi Kalori tersedia di platform lain selain Android?',
      answer:
          'Saat ini, Aplikasi Kalori hanya tersedia untuk perangkat Android. Namun, kami sedang mengembangkan versi iOS dan akan segera merilisnya.',
    ),
    FAQItem(
      question: 'Apakah Aplikasi Kalori gratis?',
      answer:
          'Ya, Aplikasi Kalori dapat diunduh dan digunakan secara gratis. Namun, kami juga menyediakan versi berbayar dengan fitur tambahan dan tanpa iklan.',
    ),
    // Tambahkan item FAQ lainnya di sini
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FAQ Aplikasi Kalori'),
          backgroundColor: Colors.deepOrange,
        ),
        body: ListView.builder(
          itemCount: faqItems.length,
          itemBuilder: (context, index) {
            return buildFAQCard(faqItems[index]);
          },
        ),
      ),
    );
  }

  Widget buildFAQCard(FAQItem faqItem) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: ExpansionTile(
        title: Text(
          faqItem.question,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(faqItem.answer),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
