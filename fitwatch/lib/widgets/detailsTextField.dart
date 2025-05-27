import 'package:flutter/material.dart';

Widget buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'this is a required field';
        } else {
          return null;
        }
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: Color.fromRGBO(96, 181, 255, 1), width: 2),
        ),
      ),
      keyboardType:
          (label == 'Name') ? TextInputType.text : TextInputType.number,
    ),
  );
}
