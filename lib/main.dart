import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youpaint/view/drawing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouPaint',
       theme: ThemeData(
        scaffoldBackgroundColor: Colors.white12,
        useMaterial3: true,
        textTheme: GoogleFonts.bricolageGrotesqueTextTheme(),
                visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      home: DrawingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

