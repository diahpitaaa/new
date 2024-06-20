// lib/welcome_page.dart
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/dentalwhite.png', height: 200),
            SizedBox(height: 20),
            Text(
              'DENTAL WHITE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Halo! Kami Siap Membantu\nAnda Merawat Gigi dengan Lebih Baik.\nBersiaplah untuk Senyum Sehat dan Menawan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signup');
              },
              child: Text('MULAI SEKARANG'),
            ),
          ],
        ),
      ),
    );
  }
}
