import 'package:flutter/material.dart';

class ToolModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? route;

  ToolModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.route,
  });
}

class EditToolModel {
  final IconData icon;
  final String title;
  final String? route;

  EditToolModel({
    required this.icon,
    required this.title,
    this.route,
  });
}

class ConvertToolModel {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? route;

  ConvertToolModel({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.route,
  });
}
