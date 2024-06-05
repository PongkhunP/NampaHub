
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'NAMPAHUB',
      style: TextStyle(
          fontFamily: GoogleFonts.rubikWetPaint().fontFamily,
          color: Colors.white,
          fontSize: 32),
    );
  }
}
