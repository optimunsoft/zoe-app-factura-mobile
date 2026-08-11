import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Servicio reutilizable para generar un archivo local de prueba
/// y abrirlo en el menú nativo de compartir (WhatsApp, etc.).
class WhatsAppShareService {
  /// Genera un archivo temporal y lo comparte con el sheet nativo.
  ///
  /// Flujo:
  /// 1) Ruta temporal → 2) Escritura del archivo → 3) Share nativo.
  Future<void> compartirArchivoDePrueba({
    String? nombreArchivo,
    String? mensaje,
  }) async {
    final String fileName = nombreArchivo ?? 'prueba_whatsapp.txt';
    final String text =
        mensaje ??
        'Archivo de prueba generado desde Zoe POS (${DateTime.now().toIso8601String()}).';

    // 1) Directorio temporal del dispositivo.
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}${Platform.pathSeparator}$fileName';

    // 2) Crear / sobrescribir el archivo físico.
    final File file = File(filePath);
    await file.writeAsString(text, flush: true);

    // 3) Menú nativo de compartir (equivalente moderno a Share.shareXFiles).
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(file.path)],
          text: text,
          subject: 'Compartir desde Zoe POS',
        ),
      );
    } catch (e) {
      // Fallo defensivo: el llamador puede mostrar feedback al usuario.
      throw WhatsAppShareException(
        'No se pudo abrir el menú de compartir: $e',
      );
    }
  }
}

/// Error tipado para fallos al compartir.
class WhatsAppShareException implements Exception {
  WhatsAppShareException(this.message);

  final String message;

  @override
  String toString() => 'WhatsAppShareException: $message';
}
