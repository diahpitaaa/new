import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulePage extends StatelessWidget {
  final Map<String, dynamic> appointmentData;

  const SchedulePage({Key? key, required this.appointmentData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Janji Temu'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              'Detail Janji Temu:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 3, // Adjust as needed to fit the content
                    ),
                    children: [
                      _buildInfoTile(Icons.person, 'Dokter', appointmentData['doctorName']),
                      _buildInfoTile(Icons.person_outline, 'Nama Pasien', appointmentData['patientName']),
                      _buildInfoTile(Icons.text_fields, 'Nama Depan', appointmentData['firstName']),
                      _buildInfoTile(Icons.text_fields, 'Nama Belakang', appointmentData['lastName']),
                      _buildInfoTile(Icons.home, 'Alamat', appointmentData['address']),
                      _buildInfoTile(Icons.local_hospital, 'Klinik', appointmentData['clinic']),
                      _buildInfoTile(Icons.date_range, 'Tanggal', appointmentData['date']),
                      _buildInfoTile(Icons.access_time, 'Waktu', appointmentData['time']),
                      _buildInfoTile(Icons.calendar_today, 'Jenis Janji Temu', appointmentData['appointmentType']),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          onPressed: () {
                            _cancelAppointment(appointmentData['id'], context);
                          },
                          child: Text(
                            'Cancel Appointment',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 30),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
  void _cancelAppointment(String appointmentId, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final username = storedUsername != null && storedUsername.isNotEmpty ? storedUsername : 'anonymous';

    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(username)
        .collection('appointments')
        .doc(appointmentId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment cancelled successfully')),
    );

    Navigator.pop(context, true);
  }
