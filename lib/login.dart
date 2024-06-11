import 'package:flutter/material.dart';
import 'package:test_project/patient_details_screen.dart';
import 'package:http/http.dart' as http;

import 'Verify_Code_Screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  Future<void> sendVerificationCode(String email) async {
    final response = await http.post(
      Uri.parse(
          'http://pharmaprosuu.runasp.net/api/Patient/SendVerificationCode/$email'),
    );
    if (response.statusCode == 200) {
      // Navigate to VerifyCodeScreen upon successful code sending
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyCodeScreen(email: email)),
      );
    } else {
      // Display error message if code sending fails
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send verification code.'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8,
                  top: 55),
              child: Image.asset('assets/images/logo.png'),
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                  label: Text(
                    ' Email',
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
                  sendVerificationCode(_emailController.text);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Color.lerp(Color(0xff1e3278), Colors.blue, 0.6)!,
                  ),
                ),
                child: Text(
                  'Login',
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
