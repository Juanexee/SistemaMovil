// =========================================================
// api_client.dart
// El mensajero de la app. Ahora soporta todos los metodos
// HTTP y agrega el token JWT automaticamente en cada peticion
// =========================================================
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../services/secure_storage_service.dart';

class ApiClient {
  // Reutilizo el mismo cliente HTTP para no abrir una conexion nueva cada vez
  final http.Client _client;
  // Lo uso para obtener el token JWT guardado
  final SecureStorageService _storage;

  static const Duration _timeout = Duration(seconds: 20);

  // Constructor: recibo el servicio de almacenamiento para poder leer el token
  ApiClient(this._storage) : _client = http.Client();

  // -----------------------------------------------------------
  // _buildHeaders — construye los headers para cada peticion
  // Siempre mando Content-Type JSON. Si hay token guardado,
  // agrego el header Authorization con el Bearer token.
  // -----------------------------------------------------------
  Future<Map<String, String>> _buildHeaders() async {
    final token = await _storage.getToken();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    // Si el usuario ya inicio sesion, mando su token en cada peticion
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // -----------------------------------------------------------
  // GET — Para leer datos (listas, objetos, KPIs, etc.)
  // queryParameters es opcional, sirve para filtros en la URL
  // Ejemplo: /ventas/filtrar?fechaInicio=2024-01-01
  // -----------------------------------------------------------
  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path')
        .replace(queryParameters: queryParameters);
    final headers = await _buildHeaders();
    final response = await _client.get(uri, headers: headers).timeout(_timeout);
    return _handleResponse(response);
  }

  // -----------------------------------------------------------
  // POST — Para crear datos (login, insertar, registrar)
  // body es el objeto que mando al servidor como JSON
  // -----------------------------------------------------------
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final headers = await _buildHeaders();
    final response = await _client
        .post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_timeout);
    return _handleResponse(response);
  }

  // -----------------------------------------------------------
  // PUT — Para actualizar un registro completo
  // -----------------------------------------------------------
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final headers = await _buildHeaders();
    final response = await _client
        .put(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_timeout);
    return _handleResponse(response);
  }

  // -----------------------------------------------------------
  // PATCH — Para actualizar solo un campo o estado
  // Ejemplo: cambiar estado de un grupo de pedidos
  // -----------------------------------------------------------
  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final headers = await _buildHeaders();
    final response = await _client
        .patch(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_timeout);
    return _handleResponse(response);
  }

  // -----------------------------------------------------------
  // DELETE — Para eliminar un registro
  // -----------------------------------------------------------
  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path');
    final headers = await _buildHeaders();
    final response =
        await _client.delete(uri, headers: headers).timeout(_timeout);
    return _handleResponse(response);
  }

  // -----------------------------------------------------------
  // _handleResponse — Maneja la respuesta del servidor
  // Codigos 200-299 = exito, cualquier otro = error
  // -----------------------------------------------------------
  dynamic _handleResponse(http.Response response) {
    // Exito: el servidor respondio OK (200, 201, 204, etc.)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Si la respuesta esta vacia (ej: DELETE exitoso), regreso null
      if (response.body.trim().isEmpty) return null;
      // Si hay datos, los convierto de JSON a objeto Dart (o texto plano si no es JSON)
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return response.body;
      }
    } else {
      // Error del servidor — lo informo con el codigo y mensaje
      throw Exception(
        'Error HTTP ${response.statusCode}: ${response.body}',
      );
    }
  }
}
