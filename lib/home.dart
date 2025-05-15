import 'package:flutter/material.dart';
import 'players_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to TTT'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 420,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                // Background
                Positioned(
                  top: 5,
                  child: Image.asset(
                    'assets/images/background.png',
                    width: 400,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                ),
                // Yazı görseli
                Positioned(
                  top: 158,
                  child: Image.asset(
                    'assets/images/words.png',
                    width: 130,
                  ),
                ),
                // Version badge
                Positioned(
                  bottom: -50,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.orange,
                    ),
                    child: const Center(
                      child: Text(
                        'V 1.0',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Continue button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PlayersInfoPage(),
                  ),
                );
              },
              child: const Text(
                'Continue >>',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
