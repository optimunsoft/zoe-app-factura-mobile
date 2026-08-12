import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Servicio reutilizable para compartir archivos vía el sheet nativo
/// (WhatsApp y otras apps).
class WhatsAppShareService {
  /// Genera un archivo de texto de prueba y lo comparte.
  Future<void> compartirArchivoDePrueba({
    String? nombreArchivo,
    String? mensaje,
  }) async {
    final String fileName = nombreArchivo ?? 'prueba_whatsapp.txt';
    final String text = mensaje ??
        'Archivo de prueba generado desde Zoe POS (${DateTime.now().toIso8601String()}).';

    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}${Platform.pathSeparator}$fileName';
    final File file = File(filePath);
    await file.writeAsString(text, flush: true);

    await _compartirArchivo(
      file: file,
      mimeType: 'text/plain',
      mensaje: text,
    );
  }

  /// Escribe [bytes] en un archivo temporal y abre el menú de compartir.
  Future<void> compartirBytes({
    required Uint8List bytes,
    required String nombreArchivo,
    String mimeType = 'application/pdf',
    String? mensaje,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath =
        '${tempDir.path}${Platform.pathSeparator}$nombreArchivo';
    final File file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    await _compartirArchivo(
      file: file,
      mimeType: mimeType,
      mensaje: mensaje,
    );
  }

  Future<void> _compartirArchivo({
    required File file,
    required String mimeType,
    String? mensaje,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(file.path, mimeType: mimeType)],
          text: mensaje,
          subject: 'Compartir desde Zoe POS',
        ),
      );
    } catch (e) {
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
