import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Icono de carrito con badge numérico de artículos.
class CartIconButton extends StatelessWidget {
  const CartIconButton({
    super.key,
    required this.itemCount,
    required this.onPressed,
  });

  final int itemCount;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final countLabel = itemCount > 99 ? '99+' : '$itemCount';
    final enabled = onPressed != null;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Badge(
            isLabelVisible: itemCount > 0,
            backgroundColor: AppColors.danger,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            largeSize: 20,
            label: Text(
              countLabel,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
                height: 1.1,
              ),
            ),
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
              elevation: 2,
              shadowColor: AppColors.primary.withValues(alpha: 0.4),
              child: InkWell(
                onTap: onPressed,
                borderRadius: BorderRadius.circular(10),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
