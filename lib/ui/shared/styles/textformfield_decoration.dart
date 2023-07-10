import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String label) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    labelText: "Görev $label",
    hintText: 'Görev $label ',
  );
}
