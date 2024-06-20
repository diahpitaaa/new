import 'package:aplikasi/home_page.dart';
import 'package:aplikasi/schedule_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentPage extends StatefulWidget {
  final String doctorName;
  final String patientName;
  final String appointmentType;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String doctorPhotoUrl;

  const AppointmentPage(
      {super.key,
      required this.doctorName,
      required this.patientName,
      required this.appointmentType,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.address,
      required this.doctorPhotoUrl});

  @override
  AppointmentPageState createState() => AppointmentPageState();
}

class AppointmentPageState extends State<AppointmentPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClinic;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _ageController = TextEditingController();

  final List<String> _clinics = ['RS UMUM DAERAH DR. ZAINOEL ABIDIN', 'RS UMUM DAERAH CUT MEUTIA KAB. ACEH UTARA', 'RSUP SANGLAH', 'lainnya...'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveAppointment() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString('username');
    final username = storedUsername != null && storedUsername.isNotEmpty
        ? storedUsername
        : 'anonymous';

    final appointment = {
      'doctorName': widget.doctorName,
      'patientName': widget.patientName,
      'appointmentType': widget.appointmentType,
      'firstName': widget.firstName,
      'lastName': widget.lastName,
      'phoneNumber': widget.phoneNumber,
      'address': widget.address,
      'clinic': _selectedClinic,
      'date': DateFormat('dd MMMM yyyy').format(_selectedDate!),
      'time': _selectedTime?.format(context),
    };

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(username)
          .collection('appointments')
          .add(appointment);
      _showSuccessDialog(context);
    } catch (e) {
      print('Error saving appointment: $e');
      // Handle error saving appointment
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('BERHASIL!!!!'),
          content: const Text('Jangan Lupa Datang Tepat Waktu\nSee you.....'),
          actions: <Widget>[
            TextButton(
              child: const Text('Kembali ke Menu'),
              onPressed: () {
                Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );}
            ),
            TextButton(
              child: const Text('Lihat Jadwal'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchedulePage(appointmentData: {
                      'doctorName': widget.doctorName,
                      'patientName': widget.patientName,
                      'appointmentType': widget.appointmentType,
                      'firstName': widget.firstName,
                      'lastName': widget.lastName,
                      'phoneNumber': widget.phoneNumber,
                      'address': widget.address,
                      'clinic': _selectedClinic,
                      'date': _selectedDate!.toString(),
                      'time': _selectedTime!.format(context),
                    }),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Janji Temu'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display the doctor's image and name
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          widget
                              .doctorPhotoUrl, // Replace with actual doctor image URL
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctorName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Jenis Layanan: ${widget.appointmentType}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Form for patient details, clinic selection, and appointment scheduling
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Pasien',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.firstName,
                      decoration: InputDecoration(
                        labelText: 'Nama Depan',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan nama depan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.lastName,
                      decoration: InputDecoration(
                        labelText: 'Nama Belakang',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan nama belakang';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                        labelText: 'Umur',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan umur';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: widget.address,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap masukkan alamat';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pilih Klinik',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      value: _selectedClinic,
                      items: _clinics.map((String clinic) {
                        return DropdownMenuItem<String>(
                          value: clinic,
                          child: Text(clinic),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedClinic = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Harap pilih klinik';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pilih Tanggal dan Waktu',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: Text(_selectedDate == null
                          ? 'Pilih Tanggal'
                          : 'Tanggal: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    ListTile(
                      title: Text(_selectedTime == null
                          ? 'Pilih Waktu'
                          : 'Waktu: ${_selectedTime!.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // Process the form data
                            await _saveAppointment(); // Save appointment data to Firestore
                            // ignore: use_build_context_synchronously
                            // _showSuccessDialog(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Atur Janji Temu'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
