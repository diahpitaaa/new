import 'package:aplikasi/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({super.key});

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  late Future<List<Map<String, dynamic>>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _fetchAppointments();
  }

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
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _appointmentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No appointments found.'));
                  }
                  return _buildAppointmentGrid(snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final username = storedUsername != null && storedUsername.isNotEmpty ? storedUsername : 'anonymous';
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(username)
        .collection('appointments')
        .get();
    final List<Map<String, dynamic>> articles = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add the document ID to the data map
      return data;
    }).toList();
    return articles;
  }

  Future<void> _refreshAppointments() async {
    setState(() {
      _appointmentsFuture = _fetchAppointments();
    });
  }

  Widget _buildAppointmentGrid(List<Map<String, dynamic>> appointments) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio:
          (MediaQuery.of(context).size.width / 2) / 90, // Adjust as needed
      children: appointments.map((appointment) {
        return _buildAppointmentCard(appointment);
      }).toList(),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return SizedBox(
      height: 50,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SchedulePage(appointmentData: {
                  'doctorName': appointment['doctorName'],
                  'patientName': appointment['patientName'],
                  'appointmentType': appointment['appointmentType'],
                  'firstName': appointment['firstName'],
                  'lastName': appointment['lastName'],
                  'phoneNumber': appointment['phoneNumber'],
                  'address': appointment['address'],
                  'clinic': appointment['clinic'],
                  'date': appointment['date'],
                  'time': appointment['time'],
                  'id': appointment['id'],
                }),
              ),
            );
            if (result == true) {
              _refreshAppointments(); // Refresh appointments if the result is true
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appointment['doctorName']}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${appointment['appointmentType']}',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                SizedBox(height: 2),
                Text(
                  '${appointment['date']}',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
