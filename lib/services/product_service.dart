import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:taller_2_3/models/product.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}

class ProductService {
  final String baseUrl;

  ProductService(this.baseUrl);

  Future<List<Product>> getProducts() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) => Product.fromJson(item)).toList();
      }

      if (response.statusCode == 404) {
        throw const ApiException("No se encontraron productos");
      }

      if (response.statusCode == 500) {
        throw const ApiException("El servidor no existe");
      }
      throw ApiException('Error HTTP ${response.statusCode}');
    } on TimeoutException {
      throw const ApiException('El servidor tardo mucho en responder');
    } on SocketException {
      throw const ApiException('Sin conexion a internet');
    } on http.ClientException {
      throw const ApiException('Error en la peticion');
    } on FormatException {
      throw const ApiException('Respuesta invalida del servidor');
    }
  }
}
