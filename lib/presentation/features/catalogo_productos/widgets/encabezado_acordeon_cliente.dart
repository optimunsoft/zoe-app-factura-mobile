import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/nit_verification_digit.dart';
import '../../../../domain/models/customer.dart';
import '../../../atoms/detail_info_row.dart';

/// Header compacto del cliente con acordeón de detalle.
class EncabezadoAcordeonCliente extends StatefulWidget {
  const EncabezadoAcordeonCliente({
    super.key,
    required this.customer,
    this.onChangeCustomer,
    this.onExpandedChanged,
  });

  static const animDuration = Duration(milliseconds: 220);

  final Customer customer;
  final VoidCallback? onChangeCustomer;
  final ValueChanged<bool>? onExpandedChanged;

  @override
  State<EncabezadoAcordeonCliente> createState() =>
      _EncabezadoAcordeonClienteState();
}

class _EncabezadoAcordeonClienteState extends State<EncabezadoAcordeonCliente> {
  bool _expanded = false;
  Timer? _collapseNotifyTimer;

  String get _todayLabel {
    final formatted =
        DateFormat("d 'de' MMMM 'de' y", 'es').format(DateTime.now());
    if (formatted.isEmpty) return formatted;
    return '${formatted[0].toUpperCase()}${formatted.substring(1)}';
  }

  @override
  void dispose() {
    _collapseNotifyTimer?.cancel();
    super.dispose();
  }

  void _toggle() {
    final next = !_expanded;
    setState(() => _expanded = next);
    _collapseNotifyTimer?.cancel();
    if (next) {
      widget.onExpandedChanged?.call(true);
    } else {
      // Mantener altura del AppBar hasta que termine el colapso.
      _collapseNotifyTimer = Timer(EncabezadoAcordeonCliente.animDuration, () {
        if (!mounted) return;
        widget.onExpandedChanged?.call(false);
      });
    }
  }

  String get _nitLabel {
    final c = widget.customer;
    final stored = c.taxId?.trim();
    final dv = (stored != null && stored.isNotEmpty)
        ? stored
        : NitVerificationDigit.calculateAsString(c.documentNumber);
    if (dv == null || dv.isEmpty) return c.documentNumber;
    return '${c.documentNumber} - $dv';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.customer;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: AppTextStyles.label.copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _todayLabel,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.expand_more_rounded,
                    size: 22,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity),
          secondChild: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailInfoRow(
                  icon: Icons.badge_outlined,
                  label: 'Nit',
                  value: _nitLabel,
                ),
                DetailInfoRow(
                  icon: Icons.email_outlined,
                  label: 'Correo',
                  value: c.email.isEmpty ? '—' : c.email,
                ),
                DetailInfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Teléfono',
                  value: c.phone.isEmpty ? '—' : c.phone,
                ),
                DetailInfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Dirección',
                  value: [
                    c.address,
                    c.city,
                  ].where((e) => e.isNotEmpty).join(', ').isEmpty
                      ? '—'
                      : [c.address, c.city]
                          .where((e) => e.isNotEmpty)
                          .join(', '),
                ),
                if (widget.onChangeCustomer != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: widget.onChangeCustomer,
                      icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                      label: const Text('Cambiar cliente'),
                    ),
                  ),
              ],
            ),
          ),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: EncabezadoAcordeonCliente.animDuration,
        ),
      ],
    );
  }
}

/// Alias legacy — usar [EncabezadoAcordeonCliente].
typedef CustomerAccordionHeader = EncabezadoAcordeonCliente;
