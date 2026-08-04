import 'package:intl/intl.dart';

abstract final class CurrencyFormat {
  static final NumberFormat _fmt = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
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
}
