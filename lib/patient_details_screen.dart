import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'prescription_details_page.dart';

class PatientDetailsScreen extends StatefulWidget {
  final String email; // Accept email as a parameter

  PatientDetailsScreen({required this.email});

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  Map<String, dynamic>? patientData;

  Future<void> fetchPatientData(String email) async {
    final response = await http.get(
      Uri.parse('http://pharmaprosuu.runasp.net/api/Patient/GetByEmail/$email'),
    );

    if (response.statusCode == 200) {
      setState(() {
        patientData = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPatientData(
        widget.email); // Fetch patient data using the provided email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: patientData != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Name: ',
                          style: TextStyle(
                            color: Color(0xff1e3278),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        TextSpan(
                          text: '${patientData!['name']}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Age: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xff1e3278),
                          ),
                        ),
                        TextSpan(
                          text: '${patientData!['age']}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Email: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xff1e3278),
                          ),
                        ),
                        TextSpan(
                          text: '${patientData!['email']}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Address: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xff1e3278),
                          ),
                        ),
                        TextSpan(
                          text: '${patientData!['address']}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Prescriptions:',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1e3278)),
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: patientData!['prescriptions'].length,
                      itemBuilder: (context, index) {
                        var prescription = patientData!['prescriptions'][index];
                        return Card(
                          elevation: 5,
                          color: Color(0xff1e3278),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                          child: ListTile(
                            title: Text(
                              'Diagnosis: ${prescription['diagnosis']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              'Date: ${prescription['dateOfCreation']}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white54),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrescriptionDetailsPage(
                                    prescriptionId: prescription['id'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
