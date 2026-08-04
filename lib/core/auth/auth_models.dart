// Modelos simples del login (parseo directo del JSON).

class AuthUser {
  AuthUser({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.rol,
    required this.empresa,
    required this.categoria,
    required this.ivaIncluido,
    required this.integracionContable,
    required this.manejaInventario,
    this.sucursalId,
    this.sucursalNombre,
  });

  final String nombre;
  final String apellido;
  final String correo;
  final int rol;
  final String empresa;
  final String categoria;
  final bool ivaIncluido;
  final bool integracionContable;
  final bool manejaInventario;
  final int? sucursalId;
  final String? sucursalNombre;

  String get fullName => '$nombre $apellido'.trim();

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final sucursal = json['sucursal'];
    return AuthUser(
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
      rol: (json['rol'] as num?)?.toInt() ?? 0,
      empresa: json['empresa'] ?? '',
      categoria: json['categoria'] ?? '',
      ivaIncluido: json['iva_incluido'] == true,
      integracionContable: json['integracion_contable'] == true,
      manejaInventario: json['maneja_inventario'] == true,
      sucursalId: sucursal is Map ? (sucursal['id'] as num?)?.toInt() : null,
      sucursalNombre: sucursal is Map ? sucursal['nombre'] as String? : null,
    );
  }
}

class LoginResult {
  LoginResult({
    required this.status,
    required this.message,
    required this.user,
    required this.tokenType,
    required this.accessToken,
    this.modulos = const [],
  });

  final bool status;
  final String message;
  final AuthUser user;
  final String tokenType;
  final String accessToken;
  final List<dynamic> modulos;

  String get bearerToken => '$tokenType $accessToken';

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    final auth = json['authorization'] as Map<String, dynamic>? ?? {};
    return LoginResult(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      user: AuthUser.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
      tokenType: auth['token_type']?.toString() ?? 'Bearer',
      accessToken: auth['access_token']?.toString() ?? '',
      modulos: json['modulos'] is List ? json['modulos'] as List : const [],
    );
  }
}
