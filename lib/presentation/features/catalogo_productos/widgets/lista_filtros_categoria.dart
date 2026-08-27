import 'package:flutter/material.dart';

import '../../../../core/layout/ancho_vista.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../modules/categories/domain/models/categories_models.dart';
import 'pastilla_categoria.dart';

/// Fila horizontal de categorías del catálogo. Siempre arranca a la izquierda.
class ListaFiltrosCategoria extends StatelessWidget {
  const ListaFiltrosCategoria({
    super.key,
    required this.categorias,
    required this.seleccionada,
    required this.onSeleccionar,
    this.cargando = false,
  });

  final List<Category> categorias;
  final Category? seleccionada;
  final ValueChanged<Category?> onSeleccionar;
  final bool cargando;

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: AppSpacing.xl,
            height: AppSpacing.xl,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AnchoVista.paddingHorizontal(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            PastillaCategoria(
              label: 'Todos',
              selected: seleccionada == null,
              onTap: () => onSeleccionar(null),
            ),
            for (final categoria in categorias)
              PastillaCategoria(
                label: categoria.name,
                selected: seleccionada?.id == categoria.id,
                onTap: () => onSeleccionar(categoria),
              ),
          ],
        ),
      ),
    );
  }
}
