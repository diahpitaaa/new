import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodata Pembuat Aplikasi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BiodataPage(),
    );
  }
}

class BiodataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biodata Pembuat Aplikasi'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            BiodataCard(
              nama: 'Septiono Raka Wahyu Sasongko',
              npm: '22082010071',
              kelas: 'Paralel B',
              linkGithub: 'https://github.com/yonojaml',
              email: '22082010071@student.upnjatim.ac.id',
              foto: 'assets/raka.jpg',
            ),
            SizedBox(width: 16),
            BiodataCard(
              nama: 'Diah Pitaloka Rachmawati',
              npm: '22082010053',
              kelas: 'Paralel B',
              linkGithub: 'https://github.com/diahpitaaa',
              email: 'diahpitaaa@gmail.com',
              foto: 'assets/pita.jpg',
            ),
          ],
        ),
      ),
    );
  }
}

class BiodataCard extends StatelessWidget {
  final String nama;
  final String npm;
  final String kelas;
  final String linkGithub;
  final String email;
  final String foto;

  const BiodataCard({
    Key? key,
    required this.nama,
    required this.npm,
    required this.kelas,
    required this.linkGithub,
    required this.email,
    required this.foto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 300,
        height: 400, // Specify a fixed height to avoid overflow
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage(foto),
                  radius: 50,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Nama:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                nama,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'NPM:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                npm,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Kelas:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                kelas,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Link GitHub:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Text(
                  linkGithub,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () => _launchURL(linkGithub),
              ),
              SizedBox(height: 8),
              Text(
                'Email:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
