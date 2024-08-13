import 'package:flutter/material.dart';

showSnack(context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
    ),
    backgroundColor: Colors.amber.shade900,
  ));
}
