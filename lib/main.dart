import 'package:flutter/material.dart';
import 'package:web3_example/page/home_page.dart';
import 'package:web3_example/page/owner_page.dart';
import 'package:web3_example/page/voter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART VOTING',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: VoterPage.route,
      routes: {
        HomePage.route: (context) => const HomePage(),
        OwnerPage.route: (context) => const OwnerPage(),
        VoterPage.route: (context) => const VoterPage(),
      },
    );
  }
}
