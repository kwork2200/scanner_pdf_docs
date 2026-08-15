import 'package:flutter/material.dart';

class AccountSettingsModel {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? route;
  final VoidCallback? onTap;

  AccountSettingsModel({
    required this.icon,
    required this.title,
    this.subtitle,
    this.route,
    this.onTap,
  });
}
