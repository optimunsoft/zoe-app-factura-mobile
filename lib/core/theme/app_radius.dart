import 'package:flutter/material.dart';

/// Radios centralizados del design system.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgTop =>
      const BorderRadius.vertical(top: Radius.circular(lg));
}
