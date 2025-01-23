import 'package:flutter/material.dart';

Widget buildDropdownField({
  required String? value,
  required List<String> items,
  required String label,
  required String hint,
  required Function(String?) onChanged,
  context
}) {
  return DropdownButtonFormField<String>(
    value: value,
    items: items.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item),
      );
    }).toList(),
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    ),
    validator: (value) => value == null ? 'هذا الحقل مطلوب' : null,
  );
}