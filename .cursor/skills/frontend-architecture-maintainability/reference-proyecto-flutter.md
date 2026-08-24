# Referencia: convenciones Flutter de este proyecto

Complemento del skill `frontend-architecture-maintainability` para **zoe-app-factura-mobile**.

## Capas de presentación

```text
lib/presentation/
├── atoms/              # UI básica (AppButton, MoneyText, AppBadge…)
├── molecules/          # Patrones reutilizables (BarraBusquedaEscaner, MosaicoConBorde…)
├── organisms/          # Secciones compartidas (GrillaProductos, SheetInferiorApp, NavInferiorApp)
├── pages/              # SOLO pantallas principales (tabs / entry points)
└── features/           # Flujos completos: page + widgets del flujo
```

## `pages/` — pantallas principales (español)

| Carpeta | Ventana |
|---------|---------|
| `inicio_sesion/` | Login |
| `navegacion_principal/` | Shell con tabs |
| `inicio/` | Dashboard |
| `venta/` | Tab Venta (router) |
| `historial_ventas/` | Tab Facturas |
| `reportes/` | Tab Reportes |

**Regla:** no agregar widgets de flujo aquí. Solo la page principal o re-export del feature.

## `features/` — flujos por ventana (español)

| Feature | Contenido |
|---------|-----------|
| `seleccion_cliente/` | Buscar / elegir cliente |
| `crear_cliente/` | Formulario alta tercero |
| `catalogo_productos/` | Grid, categorías, detalle |
| `revisar_venta/` | Carrito / checkout |
| `resumen_venta/` | Impuestos y retenciones |
| `medios_pago/` | Pagos + ReteFuente |
| `vista_previa_ticket/` | Ticket térmico |
| `historial_ventas/` | Lista, filtros, detalle |
| `inicio/` | Widgets del dashboard |
| `inicio_sesion/` | Animación + formulario login |
| `reportes/` | Widgets de reportes |

**Regla:** archivos y clases en **español** (`lista_clientes.dart` / `ListaClientes`).  
`typedef` legacy solo para compatibilidad (`typedef CustomerList = ListaClientes`).

## Dominio y estado (fuera de widgets)

```text
lib/modules/<dominio>/
├── domain/models/
├── domain/mappers/
├── domain/queries/     # builders de query
├── services/           # HTTP
└── store/              # ChangeNotifier / estado UI
```

Ejemplos: `SalesHistoryStore`, `CheckoutTaxCalculator`, `CrearClientePayloadBuilder`.

**Regla:** cálculos, mapeo API, payloads y paginación viven en domain/store, no en widgets.

## Mapeo Atomic Design → Flutter

| Nivel | Ubicación típica | Ejemplo |
|-------|------------------|---------|
| Atom | `presentation/atoms/` | `AppButton`, `MoneyText` |
| Molecule | `presentation/molecules/` | `BarraFiltrosActivos`, `ItemListaVenta` |
| Organism | `presentation/organisms/` o `features/*/widgets/` | `GrillaProductos`, `PanelRetenciones` |
| Page | `pages/` o `features/*/*_page.dart` | `HistorialVentasPage`, `MediosPagoPage` |

Sheets reutilizables: `SheetInferiorApp.show()` (no duplicar handle/cerrar).

## Tokens de diseño

- `lib/core/theme/app_spacing.dart`
- `lib/core/theme/app_radius.dart`
- `lib/core/theme/app_colors.dart`, `app_text_styles.dart`
- `lib/core/theme/app_breakpoints.dart` (`movil` 600 / `tablet` 840 / `escritorio` 1200)
- `lib/core/layout/ancho_vista.dart` — clase de ancho, padding, columnas
- `lib/presentation/organisms/plantilla_adaptativa.dart` — `PlantillaAdaptativa`, `PlantillaDosColumnas`

No usar números mágicos de padding/radius si existe token.

## Checklist rápido al crear un widget nuevo

1. ¿Es reutilizable entre ventanas? → `molecules/` u `organisms/`
2. ¿Es específico de un flujo? → `features/<ventana>/widgets/`
3. ¿Nombre en español describe la ventana/responsabilidad?
4. ¿La page solo compone y conecta store?
5. ¿Correr `flutter analyze lib` sin errores?

## Anti-patrones en este repo

- God widget con 14 controllers + API + 6 secciones UI en un solo archivo
- Tax math duplicado en varias pages (usar `CheckoutTaxCalculator`)
- Sheet con shell copiado (usar `SheetInferiorApp`)
- Carpeta `pages/checkout/` con widgets internos (mover a `features/`)
- Nombres en inglés para archivos nuevos (`payment_methods_panel.dart`)
