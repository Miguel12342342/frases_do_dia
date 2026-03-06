import 'package:flutter/material.dart';
import 'presentation/pages/home_page.dart'; // Importa o seu novo Widget

void main (){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Frases do Dia',
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0A0B1A), // Deep indigo
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7B61FF), // Soft purple/indigo
        secondary: Color(0xFF00E5FF), // Soft cyan
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white70),
        bodyMedium: TextStyle(color: Colors.white54),
      ),
    ),
    home: const Home(),
  ));
}