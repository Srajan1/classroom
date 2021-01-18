import 'package:flutter/material.dart';

formField(controller, title, context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      validator: ((value) => value.isEmpty ? 'Enter a value' : null),
      controller: controller,
      decoration: InputDecoration(
        hintText: title,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
    ),
  );
}
