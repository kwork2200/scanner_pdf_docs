import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  AppUtils._();

  static Future<void> openUrl(
    String urlString, {
    BuildContext? context,
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final uri = Uri.tryParse(urlString);
    if (uri == null || urlString.isEmpty) {
      _showError(context, 'Invalid URL');
      return;
    }

    try {
      await launchUrl(uri, mode: mode);
    } catch (e) {
      debugPrint('AppUtils.openUrl error: $e');
      _showError(context, 'Could not open link');
    }
  }

  static void _showError(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
