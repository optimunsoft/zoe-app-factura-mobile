import 'package:flutter/material.dart';

/// Radios centralizados del design system.
///
/// Escala única y su uso. No introducir valores intermedios:
/// - [sm] badges, pastillas y cajas de icono dentro de otra superficie
/// - [md] botones, inputs y filas de lista
/// - [lg] tarjetas y contenedores de contenido
/// - [sheet] bottom sheets (ver [sheetTop])
/// - [pill] chips y filtros completamente redondeados
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double sheet = 20;
  static const double pill = 999;

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get pillAll => BorderRadius.circular(pill);

  static BorderRadius get sheetTop =>
      const BorderRadius.vertical(top: Radius.circular(sheet));
}
