import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart' as Home; // Import home_page.dart with alias Home
import 'profile_page.dart';
import 'doctors_list_page.dart';
import 'hospital_list_page.dart';
import 'chat_room_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DentalWhiteApp());
}

class DentalWhiteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental White',
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => Home.HomePage(), // Use the alias to refer to HomePage
        '/profile': (context) => ProfilePage(),
        '/doctors': (context) => DoctorsListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/chat') {
          return MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              doctorName: 'Dr. Smith',
              patientName: 'John Doe',
            ),
          );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go to Chat Room'),
          onPressed: () {
            Navigator.pushNamed(context, '/chat'); // Navigate to ChatRoomPage
          },
        ),
      ),
    );
  }
}
