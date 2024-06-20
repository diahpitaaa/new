import 'package:aplikasi/schedule_list_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'doctors_list_page.dart';
import 'biodata_page.dart';
import 'hospital_list_page.dart';
import 'chat_room_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    HomeContent(),
    ScheduleListPage(),
    ChatBoxPage(),
    BiodataPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maurent', style: TextStyle(color: Colors.white)),
            Text('We are happy to see you again', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ChatBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomPage(
            doctorName: 'Dr. Smith',
            patientName: 'John Doe',
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Box'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat Datang! Enjoy your DentalWhite!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            _buildUsageCarousel(),
            SizedBox(height: 20),
            Text(
              'Aktivitas',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            _buildSpecialityGrid(context),
            SizedBox(height: 20),
            Text(
              'Artikel Gigi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            _buildArticleGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialityGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 0.8,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildSpecialityCard('Nama Dokter', 'assets/doctor.jpg', context, DoctorsListPage()),
        _buildSpecialityCard('Rumah Sakit Rujukan', 'assets/hospital.jpg', context, HospitalListPage()),
        _buildSpecialityCard('Klinik Gigi', 'assets/klinik.jpeg', context, MyApp()),
      ],
    );
  }

  Widget _buildArticleGrid(BuildContext context) {
    return Container(
      height: 500,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: [
          _buildArticleCard(
            context,
            'Yuk, Jaga Kesehatan Gigi dan Gusi dengan Pasta Gigi yang Tepat',
            'assets/article1.jpg',
            'Rutin menyikat gigi memang penting untuk menjaga kesehatan gigi dan gusi. Lalu, bagaimana pasta gigi...',
            'https://www.alodokter.com/yuk-jaga-kesehatan-gigi-dan-gusi-dengan-pasta-gigi-yang-tepat',
          ),
          _buildArticleCard(
            context,
            'Gosok Gigi Saat Puasa, Ini Waktu Terbaik dan Tips Melakukannya',
            'assets/article2.jpg',
            'Gosok gigi saat puasa boleh dilakukan, kok, asalkan dengan cara yang benar. Nah, supaya gigi dan...',
            'https://www.alodokter.com/gosok-gigi-saat-puasa-ini-waktu-terbaik-dan-tips-melakukannya',
          ),
          _buildArticleCard(
            context,
            'Mengenal Dokter Gigi dan Kapan Harus Memeriksakan Gigi',
            'assets/article3.jpg',
            'Dokter gigi adalah seorang dokter yang fokus pada kesehatan gigi dan mulut. Mereka berperan dalam...',
            'https://www.alodokter.com/mengenal-dokter-gigi-dan-kapan-saatnya-memeriksakan-gigi',
          ),
          _buildArticleCard(
            context,
            'Tips Menjaga Kebersihan Gigi dan Mulut di Masa Pandemi',
            'assets/article4.jpg',
            'Selama pandemi, menjaga kebersihan gigi dan mulut menjadi semakin penting. Berikut beberapa tips...',
            'https://www.alodokter.com/tips-aman-menyikat-gigi-anak',
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialityCard(String title, String imagePath, BuildContext context, Widget page) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, String title, String imagePath, String summary, String url) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          _launchURL(url);
        },
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 5),
                  Text(summary, style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          ],
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

  Widget _buildUsageCarousel() {
    final List<Widget> usageSteps = [
      _buildUsageStep(
        'Membersihkan Karang Gigi secara efektif dan mudah. Tidak perlu membayar mahal!',
        'assets/carousel1.jpg',
      ),
      _buildUsageStep(
        'Gigi tampak rapi dengan memasang behel! Pilih warna behel kesukaan Anda!',
        'assets/carousel2.jpg',
      ),
      _buildUsageStep(
        'Atasi rasa nyeri gigi berlubang tanpa rasa sakit. Coba sekarang!',
        'assets/carousel3.jpg',
      ),
    ];

    return CarouselSlider(
      items: usageSteps,
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {},
      ),
    );
  }

  Widget _buildUsageStep(String description, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(description, style: TextStyle(fontSize: 14, color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
