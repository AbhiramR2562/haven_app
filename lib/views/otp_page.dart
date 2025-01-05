import 'package:flutter/material.dart';

class OtpPage extends StatelessWidget {
  final String verificationId;
  const OtpPage({
    super.key,
    required this.verificationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("OTP"),
      ),
    );
  }
}
