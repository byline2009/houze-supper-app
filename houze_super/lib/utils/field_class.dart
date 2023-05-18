import 'package:flutter/material.dart';

class FieldInfo {
  final String title;
  final String hint;
  final TextEditingController controller;

  const FieldInfo({
    @required this.title,
    @required this.hint,
    @required this.controller,
  });
}
