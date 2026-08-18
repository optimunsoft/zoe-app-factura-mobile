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

  @override
  Widget build(BuildContext context) {
    final empresa = (user?.empresa.isNotEmpty == true)
        ? user!.empresa
        : 'ZOE';
    final sucursal = user?.sucursalNombre?.trim();
    final nombre = user?.fullName.trim();
    final correo = user?.correo.trim();

    return ColoredBox(
      color: AppColors.primaryLight,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LogoZoe(
                height: 36,
                invertido: Theme.of(context).brightness == Brightness.dark,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                empresa.toUpperCase(),
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textoSeleccionado,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (sucursal != null && sucursal.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  sucursal,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (nombre != null && nombre.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  nombre,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (correo != null && correo.isNotEmpty)
                Text(
                  correo,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
