import 'package:flutter/material.dart';
import 'package:test_project/prescription_details_page.dart';
import 'patient_details_screen.dart'; // Import PatientDetailsScreen
import 'login.dart'; // Import LoginScreen

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      //PrescriptionDetailsPage.routeName: (context) => PrescriptionDetailsPage(prescriptionId: 1),

      //Prescription.routeName: (context) => Prescription(),
    },
    home: LoginScreen(), // Start with LoginScreen
  ));
}
