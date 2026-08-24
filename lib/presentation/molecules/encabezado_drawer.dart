import 'package:flutter/material.dart';

import '../../core/auth/auth_models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../atoms/logo_zoe.dart';

/// Cabecera del drawer: marca, empresa y usuario de sesión.
class EncabezadoDrawer extends StatelessWidget {
  const EncabezadoDrawer({super.key, this.user});

  final AuthUser? user;

  String get _lineaSucursal {
    final empresa = (user?.empresa.isNotEmpty == true)
        ? user!.empresa
        : 'ZOE';
    final sucursal = user?.sucursalNombre?.trim();
    if (sucursal == null || sucursal.isEmpty) return empresa.toUpperCase();
    return '${empresa.toUpperCase()} · ${sucursal.toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final nombre = user?.fullName.trim();
    final correo = user?.correo.trim();

    return ColoredBox(
      color: AppColors.primaryLight,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogoZoeConFirma(
                    logoHeight: 40,
                    firmaSize: 10,
                    invertido: oscuro,
                    firmaColor: oscuro
                        ? Colors.white.withValues(alpha: 0.9)
                        : AppColors.primaryDark,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (nombre != null && nombre.isNotEmpty)
                    Text(
                      nombre.toUpperCase(),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textoSeleccionado,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    _lineaSucursal,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (correo != null && correo.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      correo,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: AppColors.border),
          ],
        ),
      ),
    );
  }
}
