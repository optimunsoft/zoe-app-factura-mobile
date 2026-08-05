/// Cálculo del dígito de verificación (DV) según algoritmo DIAN / Colombia.
abstract final class NitVerificationDigit {
  static const _weights = [
    71, 67, 59, 53, 47, 43, 41, 37, 29, 23, 19, 17, 13, 7, 3,
  ];

  /// Devuelve el DV (0–9) o `null` si no hay dígitos en [nit].
  static int? calculate(String nit) {
    final digits = nit.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;

    final padded = digits.padLeft(15, '0');
    final base =
        padded.length > 15 ? padded.substring(padded.length - 15) : padded;

    var sum = 0;
    for (var i = 0; i < 15; i++) {
      sum += int.parse(base[i]) * _weights[i];
    }

    final residue = sum % 11;
    if (residue == 0) return 0;
    if (residue == 1) return 1;
    return 11 - residue;
  }

  static String? calculateAsString(String nit) {
    final dv = calculate(nit);
    return dv?.toString();
  }
}
