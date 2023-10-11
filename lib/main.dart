import 'package:firebase_core/firebase_core.dart';
import 'package:piring_baru/Auth/firebase.dart';
import 'package:piring_baru/Login/login_screen.dart';
import 'package:piring_baru/bloc/nav/nav_bloc.dart';
import 'package:piring_baru/dashboard/dashboard.dart';
import 'package:piring_baru/kalori/kalori.dart';

import 'package:piring_baru/model/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:page_transition/page_transition.dart';

import 'package:piring_baru/profile/profile.dart';
import 'package:piring_baru/riwayat/riwayat.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Terjadi kesalahan saat menginisialisasi Firebase: $e');
  }

  await FirebaseApi().initNotification();
  runApp(
    MultiProvider(
      // Use MultiProvider to combine multiple providers
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserProvider()), // Your ChangeNotifierProvider
        BlocProvider(create: (context) => NavBloc()), // Your BlocProvider
      ],
      child: const MyApp(),
    ),
  );

  // AwesomeNotifications().initialize(
  //   'resource://drawable/app_icon', // Ganti dengan ikon aplikasi Anda
  //   [
  //     NotificationChannel(
  //       channelKey: 'scheduled_channel',
  //       channelName: 'Scheduled Notifications',
  //       channelDescription: 'Scheduled Notifications Channel',
  //     ),
  //   ],
  // );

  // // Panggil metode untuk membuat notifikasi berulang
  // NotificationController.createRecurringNotifications();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/dashboard':
            return PageTransition(
              child: const Dashboard(),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 0),
              settings: settings,
            );
          case '/kalori':
            return PageTransition(
              child: Kalori(),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 0),
              settings: settings,
            );
          case '/riwayat':
            return PageTransition(
              child: const Riwayat(),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 0),
              settings: settings,
            );
          case '/profile':
            return PageTransition(
              child: const Profile(),
              type: PageTransitionType.fade,
              alignment: Alignment.center,
              duration: const Duration(milliseconds: 0),
              settings: settings,
            );

          // case '/profile':
          //   return PageTransition(
          //     child: Ranting(),
          //     type: PageTransitionType.fade,
          //     alignment: Alignment.center,
          //     duration: Duration(milliseconds: 400),
          //     settings: settings,
          //   );
          default:
            return null;
        }
      },
    );

    // return BlocBuilder<NavBloc, NavState>(
    //   builder: (context, state) {
    //     if (state is NavSplash) {
    //       return const Splashscreen();
    //     } else if (state is NavHello) {
    //       return const HelloScreen();
    //     } else if (state is NavLogin) {
    //       return const Login();
    //     } else if (state is NavDashboard) {
    //       return const Dashboard();
    //     } else if (state is NavChat) {
    //       return const ChatScreen();
    //     } else {
    //       return Scaffold(
    //         body: Center(
    //           child: Text(
    //             'Terjadi kesalahan, silahkan hubungi developer!',
    //             textAlign: TextAlign.center,
    //             style: Theme.of(context).textTheme.headline4,
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}
