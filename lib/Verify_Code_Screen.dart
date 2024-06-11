import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_project/patient_details_screen.dart';
import 'package:test_project/prescription_details_page.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;

  VerifyCodeScreen({required this.email});

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  TextEditingController _codeController = TextEditingController();

  Future<void> verifyCode(String email, String code) async {
    final response = await http.post(
      Uri.parse(
          'http://pharmaprosuu.runasp.net/api/Patient/VerifyCode?email=$email&code=$code'),
    );
    if (response.statusCode == 200 &&
        response.body.contains('Verification Done')) {
      // Navigate to PatientDetailsScreen upon successful code verification
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PatientDetailsScreen(email: email)),
      );
    } else {
      // Display error message if code verification fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Verification code is incorrect.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Code',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                  label: Text(
                    ' Enter Code',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xff1e3278))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey))),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  verifyCode(widget.email, _codeController.text);



                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.lerp(Color(0xff1e3278), Colors.blue, 0.6)!,
                  ),
                ),
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
