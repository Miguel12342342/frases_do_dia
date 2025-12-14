import 'package:flutter/material.dart';
import 'presentation/pages/home_page.dart'; // Importa o seu novo Widget

void main (){
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}