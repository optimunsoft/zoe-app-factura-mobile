import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_navigator.dart';
import 'theme/app_radius.dart';
import 'theme/app_spacing.dart';

/// Toasts de la app. Solo para mensajes provenientes del backend.
abstract final class AppToast {
  static void error(String message) {
    final text = message.trim();
    if (text.isEmpty) return;

    final context = appNavigatorKey.currentContext;
    if (context != null) {
      final fToast = FToast()..init(context);
      fToast.removeQueuedCustomToasts();
      fToast.showToast(
        gravity: ToastGravity.BOTTOM,
        toastDuration: const Duration(seconds: 3),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            color: const Color(0xFFDC2626),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
      return;
    }

    // Fallback nativo si aún no hay context.
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFDC2626),
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}
