import 'package:aplikasi/chat_room_page.dart' as chatRoom;
import 'package:flutter/material.dart';
import 'appointment_page.dart';


class DoctorDetailPage extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String address;
  final String description;

  DoctorDetailPage({
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.description,
  });

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  String _selectedService = 'Atur Janji Temu';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Dokter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          widget.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.address,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Pasien',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Depan',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Belakang',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Pilihan Layanan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    RadioListTile(
                      title: Text('Atur Janji Temu'),
                      value: 'Atur Janji Temu',
                      groupValue: _selectedService,
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('Konsultasi Online'),
                      value: 'Konsultasi Online',
                      groupValue: _selectedService,
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedService == 'Atur Janji Temu') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentPage(
                          doctorName: widget.name,
                          patientName: '${_firstNameController.text} ${_lastNameController.text}',
                          appointmentType: _selectedService, 
                          firstName: _firstNameController.text, 
                          lastName: _lastNameController.text,
                          phoneNumber: _phoneNumberController.text, 
                          address: _addressController.text,
                          doctorPhotoUrl: widget.imageUrl,
                        ),
                      ),
                    );
                  } else if (_selectedService == 'Konsultasi Online') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => chatRoom.ChatRoomPage(
                          doctorName: widget.name,
                          patientName: '${_firstNameController.text} ${_lastNameController.text}',
                        ),
                      ),
                    );
                  }
                },
                child: Text('Lanjutkan'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
