import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo-icon.png',
          width: 150
        )
      ),
      backgroundColor: Colors.deepOrange,
    );
  }
  
}
