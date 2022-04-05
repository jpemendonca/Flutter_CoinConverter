import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required this.label,
    this.hintText,
    this.onChanged,
    this.prefix,
    this.controller,
    this.keyboardType,
    this.initialValue,
  }) : super(key: key);
  final String label;
  final String? prefix;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? hintText;

  final TextEditingController? controller;
  final void Function(String text)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      onChanged: onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
      ],
      style: TextStyle(fontSize: 20, color: Colors.amber),
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber)),
        prefixText: prefix,
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        hintText: hintText,
        // ignore: unnecessary_null_comparison
      ),
    );
  }
}
