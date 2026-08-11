import 'package:flutter/material.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_format.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(
    this.value, {
    super.key,
    this.style,
    this.color,
    this.large = false,
    this.xl = false,
    this.hideZeroDecimals = false,
  });

  final num value;
  final TextStyle? style;
  final Color? color;
  final bool large;
  final bool xl;
  final bool hideZeroDecimals;

  @override
  Widget build(BuildContext context) {
    final base = xl
        ? AppTextStyles.moneyXl
        : large
            ? AppTextStyles.moneyLg
            : AppTextStyles.money;
    return Text(
      CurrencyFormat.money(value, hideZeroDecimals: hideZeroDecimals),
      style: (style ?? base).copyWith(color: color ?? base.color),
    );
  }
}
