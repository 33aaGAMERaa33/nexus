import 'package:flutter/material.dart';

void unknownErrorDialog(BuildContext context) {
  showDialog(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text("Ops..."),
        content: const Text("Houve um erro inesperado"),
      );
    },
  );
}