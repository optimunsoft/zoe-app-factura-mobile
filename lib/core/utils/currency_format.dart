import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

abstract final class CurrencyFormat {
  static final NumberFormat _fmt = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _groupedDecimals = NumberFormat('#,##0.00', 'en_US');

  /// Redondea a 2 decimales (centavos) para evitar errores de float.
  static double roundMoney(num value) {
    return (value * 100).roundToDouble() / 100;
  }

  /// Comparación en centavos enteros.
  static int toCents(num value) => (value * 100).round();

  static String money(num value, {bool hideZeroDecimals = false}) {
    final d = roundMoney(value);
    if (hideZeroDecimals) {
      if (d == d.roundToDouble()) {
        return NumberFormat.currency(
          locale: 'es_MX',
          symbol: '\$',
          decimalDigits: 0,
        ).format(d);
      }
    }
    return _fmt.format(d);
  }

  static String compact(num value) {
    final d = roundMoney(value);
    if (d >= 1000) {
      return NumberFormat.compactCurrency(
        locale: 'es_MX',
        symbol: '\$',
        decimalDigits: 1,
      ).format(d);
    }
    return money(d);
  }

  /// Valor para el campo: `63,435.00` (miles + 2 decimales).
  static String formatInput(num value) {
    return _groupedDecimals.format(roundMoney(value));
  }

  /// Parsea montos con miles (`,`) y decimal (`.` o `,`).
  static double parseInput(String text) {
    final parts = _splitAmount(text);
    if (parts == null) return 0;

    final normalized = parts.decimal == null || parts.decimal!.isEmpty
        ? parts.integer
        : '${parts.integer}.${parts.decimal}';
    return roundMoney(double.tryParse(normalized) ?? 0);
  }

  /// Separa parte entera y decimal.
  ///
  /// - `.` siempre es decimal.
  /// - `,` es decimal solo si tras ella hay 0–2 dígitos (p. ej. `12,5`);
  ///   si hay 3+ (`63,435`) se trata como separador de miles.
  static ({String integer, String? decimal, bool hasSeparator})? _splitAmount(
    String text,
  ) {
    final cleaned = text.trim().replaceAll(RegExp(r'[^\d.,]'), '');
    if (cleaned.isEmpty) return null;

    final lastDot = cleaned.lastIndexOf('.');
    final lastComma = cleaned.lastIndexOf(',');

    int? decimalAt;
    if (lastDot >= 0 && lastComma >= 0) {
      decimalAt = lastDot > lastComma ? lastDot : lastComma;
    } else if (lastDot >= 0) {
      decimalAt = lastDot;
    } else if (lastComma >= 0) {
      final after =
          cleaned.substring(lastComma + 1).replaceAll(RegExp(r'[^\d]'), '');
      if (after.length <= 2) {
        decimalAt = lastComma;
      }
    }

    if (decimalAt != null) {
      var integer = cleaned
          .substring(0, decimalAt)
          .replaceAll(RegExp(r'[^\d]'), '');
      integer = integer.replaceFirst(RegExp(r'^0+(?=\d)'), '');
      var decimal =
          cleaned.substring(decimalAt + 1).replaceAll(RegExp(r'[^\d]'), '');
      if (decimal.length > 2) decimal = decimal.substring(0, 2);
      return (
        integer: integer.isEmpty ? '0' : integer,
        decimal: decimal,
        hasSeparator: true,
      );
    }

    var integer = cleaned.replaceAll(RegExp(r'[^\d]'), '');
    integer = integer.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    return (
      integer: integer.isEmpty ? '0' : integer,
      decimal: null,
      hasSeparator: false,
    );
  }

  static String _formatParts({
    required String integer,
    String? decimal,
    required bool hasSeparator,
  }) {
    final grouped = _grouped.format(int.tryParse(integer) ?? 0);
    if (!hasSeparator) return grouped;
    if (decimal != null && decimal.isNotEmpty) return '$grouped.$decimal';
    return '$grouped.';
  }
}

/// Formatea en vivo: `6` → `63` → `634` → `6,343` → `63,435` → `63,435.5` → `63,435.50`
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final parts = CurrencyFormat._splitAmount(newValue.text);
    if (parts == null) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final formatted = CurrencyFormat._formatParts(
      integer: parts.integer,
      decimal: parts.decimal,
      hasSeparator: parts.hasSeparator,
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
