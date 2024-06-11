import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_widget/barcode_widget.dart';

class PrescriptionDetailsPage extends StatelessWidget {

  final int prescriptionId;

  PrescriptionDetailsPage({required this.prescriptionId});

  Future<Map<String, dynamic>> fetchPrescriptionDetails() async {
    final response = await http.get(
      Uri.parse(
          'http://pharmaprosuu.runasp.net/api/Prescription/GetById/$prescriptionId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load prescription details');
    }
  }

  Future<String> fetchMedicineName(int medicineId) async {
    final response = await http.get(
      Uri.parse(
          'http://pharmaprosuu.runasp.net/api/Medicines/GetById/$medicineId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['name'];
    } else {
      throw Exception('Failed to load medicine details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder(
        future: fetchPrescriptionDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final prescriptionData = snapshot.data as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Convert Barcode to Image
                  Center(
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      // Select the type of barcode you need
                      data: prescriptionData['barcode'],
                      // Provide the barcode data
                      width: 200,
                      height: 100,
                    ),
                  ),
                  SizedBox(height: 25),
                  // Rest of the prescription details
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Diagnosis: ',
                          style: TextStyle(
                            color: Color(0xff1e3278),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        TextSpan(
                          text: '${prescriptionData['diagnosis']}',
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
                          text: 'Date of Creation: ',
                          style: TextStyle(
                            color: Color(0xff1e3278),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        TextSpan(
                          text: '${prescriptionData['dateOfCreation']}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Text('Medicines:',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1e3278))),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          prescriptionData['medicineOfPrescriptions'].length,
                      itemBuilder: (context, index) {
                        var medicine =
                            prescriptionData['medicineOfPrescriptions'][index];
                        return FutureBuilder(
                          future: fetchMedicineName(medicine['medicineId']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final medicineName = snapshot.data as String;
                              return ListTile(
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Medicine Name: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: medicineName,
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black87,
                                          //fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Instructions: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: medicine['instructions'],
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
