import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
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
    final enteroStyle = (style ?? base).copyWith(color: color ?? base.color);
    final rounded = CurrencyFormat.roundMoney(value);
    final esEntero = rounded == rounded.roundToDouble();

    if (hideZeroDecimals && esEntero) {
      return Text(
        CurrencyFormat.money(value, hideZeroDecimals: true),
        style: enteroStyle,
      );
    }

    final parts = CurrencyFormat.moneyParts(value);
    final decimalSize = (enteroStyle.fontSize ?? 14) * 0.68;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: parts.entero, style: enteroStyle),
          TextSpan(
            text: '.${parts.centavos}',
            style: enteroStyle.copyWith(
              fontSize: decimalSize,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
