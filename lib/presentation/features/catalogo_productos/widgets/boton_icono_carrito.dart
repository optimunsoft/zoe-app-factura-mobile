import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Icono de carrito con badge numérico de artículos.
class BotonIconoCarrito extends StatelessWidget {
  const BotonIconoCarrito({
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
      padding: const EdgeInsets.only(right: 4),
      child: Center(
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
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
            child: IconButton(
              onPressed: onPressed,
              tooltip: 'Carrito',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              icon: Icon(
                Icons.shopping_cart_rounded,
                size: 26,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Alias legacy — usar [BotonIconoCarrito].
typedef CartIconButton = BotonIconoCarrito;
