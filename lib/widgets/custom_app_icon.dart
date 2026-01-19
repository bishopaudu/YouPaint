import 'package:flutter/material.dart';

class CustomAppIcon extends StatelessWidget {
  const CustomAppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.palette, color: Colors.white, size: 20),
        );
  }
}