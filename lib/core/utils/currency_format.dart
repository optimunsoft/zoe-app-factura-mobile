import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

abstract final class CurrencyFormat {
  static final NumberFormat _fmt = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
    decimalDigits: 2,
  );

  static final NumberFormat _inputFmt = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '',
    decimalDigits: 2,
  );

  static String money(num value) => _fmt.format(value);

  static String compact(num value) {
    if (value >= 1000) {
      return NumberFormat.compactCurrency(
        locale: 'es_MX',
        symbol: '\$',
        decimalDigits: 1,
      ).format(value);
    }
    return money(value);
  }

  /// Formatea un monto para el campo de entrada (sin símbolo).
  static String formatInput(num value) => _inputFmt.format(value).trim();

  /// Interpreta el texto del campo (dígitos = centavos).
  static double parseInput(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 0;
    return (double.tryParse(digits) ?? 0) / 100;
  }
}

/// Formatea el texto como moneda mientras el usuario escribe (centavos).
/// Ej.: 1 → 0.01 · 15050 → 150.50 · 100000 → 1,000.00
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final value = (double.tryParse(digits) ?? 0) / 100;
    final formatted = CurrencyFormat.formatInput(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
