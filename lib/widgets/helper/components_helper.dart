import 'package:flutter/material.dart';

class ComponentsHelper {
  static void buildSnackBar({
    required String message,
    required Color color,
    required BuildContext context,
  }) {
    final SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(15.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
