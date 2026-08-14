import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Logotipo ZOE en color, para superficies claras.
const String kZoeLogoAsset = 'assets/images/logo.png';

/// Logotipo ZOE en blanco, para fondos de marca (login).
const String kZoeLogoInvertidoAsset = 'assets/images/zoe_logo.png';

/// Firma corporativa que acompaña al logotipo.
const String kZoeFirmaTexto = 'by Optimun';

/// Estilo de la firma. El tracking amplio es parte de la marca, por eso se
/// mantiene proporcional al tamaño del texto.
TextStyle estiloFirmaZoe({required Color color, required double fontSize}) {
  return GoogleFonts.montserrat(
    color: color,
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    letterSpacing: fontSize * 0.29,
  );
}

/// Logotipo ZOE con alto fijo; el ancho se ajusta a la proporción original.
class LogoZoe extends StatelessWidget {
  const LogoZoe({super.key, this.height = 24, this.invertido = false});

  final double height;

  /// Usa la versión blanca; necesaria sobre fondos oscuros o de marca.
  final bool invertido;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      invertido ? kZoeLogoInvertidoAsset : kZoeLogoAsset,
      height: height,
      fit: BoxFit.contain,
      semanticLabel: 'ZOE',
    );
  }
}
