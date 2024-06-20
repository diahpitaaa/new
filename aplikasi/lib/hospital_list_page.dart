import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Hospital {
  final String name;
  final String address;
  final String phone;
  final String province;

  Hospital({
    required this.name,
    required this.address,
    required this.phone,
    required this.province,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      province: json['province'] ?? '',
    );
  }
}

class HospitalListPage extends StatefulWidget {
  @override
  _HospitalListPageState createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  late Future<List<Hospital>> futureHospitals;

  @override
  void initState() {
    super.initState();
    futureHospitals = fetchHospitals();
  }

  Future<List<Hospital>> fetchHospitals() async {
    final response = await http.get(Uri.parse('https://dekontaminasi.com/api/id/covid19/hospitals'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Hospital.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Rumah Sakit',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Data Rumah Sakit'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Hospital>>(
            future: futureHospitals,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: index.isEven ? Colors.blue[100] : Colors.white,
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data![index].name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            SizedBox(height: 8.0),
                            Text('Alamat: ${snapshot.data![index].address}'),
                            SizedBox(height: 4.0),
                            Text('Provinsi: ${snapshot.data![index].province}'),
                            SizedBox(height: 4.0),
                            Text('Telepon: ${snapshot.data![index].phone}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text('No data available');
              }
            },
          ),
        ),
      ),
    );
  }
}
