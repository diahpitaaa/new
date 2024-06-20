import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _nameController = TextEditingController(text: 'Maureent');
  TextEditingController _ageController = TextEditingController(text: '20 Tahun');
  TextEditingController _phoneController = TextEditingController(text: '0812 3968 4020');
  TextEditingController _genderController = TextEditingController(text: 'Perempuan');
  TextEditingController _addressController = TextEditingController(text: 'Jl Dewi Sartika Barat');

  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile User'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
              SizedBox(height: 20),
              _buildEditableField(label: 'Name', controller: _nameController,icon: Icons.person),
              _buildEditableField(label: 'Age', controller: _ageController, icon: Icons.calendar_today),
              _buildEditableField(label: 'Phone', controller: _phoneController, icon: Icons.phone),
              _buildEditableField(label: 'Gender', controller: _genderController, icon: Icons.person_outline),
              _buildEditableField(label: 'Address', controller: _addressController, icon: Icons.location_on),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: () {
                _toggleEditingMode();
                if (!_isEditing) {
                  _showUpdateSuccessSnackBar();
                  // Kirim nama yang baru ke HomePage saat profil disimpan
                  Navigator.pop(context, _nameController.text);
                }
              },
              child: Text(_isEditing ? 'Save Profile' : 'Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Menggunakan warna biru sebagai latar belakang
              ),
            ),

              SizedBox(height: 16), // Berikan jarak antara tombol dan bagian bawah
            ],
          ),
        ),
      ),
    );
  }

  void _toggleEditingMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Widget _buildEditableField({required String label, required TextEditingController controller, required IconData icon}) {
    return ListTile(
      leading: Icon(icon),
      title: _isEditing
          ? TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.blue), // Warna label biru
              ),
            )
          : Text(
              controller.text,
              style: TextStyle(color: Colors.black ), // Warna teks biru
            ),
    );
  }

  void _showUpdateSuccessSnackBar() {
    final snackBar = SnackBar(
      content: Text('Profile Updated Successfully'),
      backgroundColor: Colors.blue, // Menggunakan warna biru sebagai latar belakang SnackBar
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
