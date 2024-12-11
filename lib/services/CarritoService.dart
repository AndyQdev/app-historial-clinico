import 'package:dio/dio.dart';
import 'package:historial_medico_apk/utils/Endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarritoService {
  final Dio _dio = Dio(); // Instancia de Dio para hacer peticiones HTTP
  final String baseUrl = Endpoints.baseUrl; // Cambia por tu base URL

  // Crear un carrito si el cliente no tiene uno activo
  Future<void> crearCarrito() async {
    final prefs = await SharedPreferences.getInstance();
    final clienteId = prefs.getString('cliente_id');

    if (clienteId == null) {
      throw Exception('No se ha encontrado el cliente');
    }

    try {
      final response = await _dio.post(
        '$baseUrl${Endpoints.carritoCreate}/$clienteId',
      );

      if (response.statusCode == 200) {
        print('Carrito creado con éxito');
      } else {
        print('Error al crear el carrito');
      }
    } catch (error) {
      throw Exception('Error al crear el carrito: $error');
    }
  }

  // Agregar un ítem al carrito
  Future<void> agregarItemAlCarrito(String productoId, int cantidad, double precioUnitario) async {
    final prefs = await SharedPreferences.getInstance();
    final clienteId = prefs.getString('cliente_id');

    if (clienteId == null) {
      throw Exception('No se ha encontrado el cliente');
    }

    try {
      // Primero obtén el carrito activo del cliente
      final carritoResponse = await _dio.get('$baseUrl/api/carrito/$clienteId');
      if (carritoResponse.statusCode != 200) {
        throw Exception('No se ha encontrado un carrito activo para el cliente');
      }

      final carritoId = carritoResponse.data['id'];

      print('ID CARRITO DE COMPRAS: $carritoId ID PRODUCTO $productoId');
      // Ahora agrega el item al carrito
      final response = await _dio.post(
        '$baseUrl/api/carrito/agregar-item',
        data: {
          'carritoId': carritoId,
          'productoId': productoId,
          'cantidad': cantidad,
          'precioUnitario': precioUnitario,
        },
      );

      if (response.statusCode == 200) {
        print('Item agregado al carrito con éxito');
      } else {
        print('Error al agregar el item al carrito');
      }
    } catch (error) {
      throw Exception('Error al agregar el item al carrito: $error');
    }
  }

  // Vaciar el carrito
  Future<void> vaciarCarrito() async {
    final prefs = await SharedPreferences.getInstance();
    final clienteId = prefs.getString('cliente_id');

    if (clienteId == null) {
      throw Exception('No se ha encontrado el cliente');
    }

    try {
      // Obtener el carrito activo del cliente
      final carritoResponse = await _dio.get('$baseUrl/carrito/$clienteId');
      if (carritoResponse.statusCode != 200) {
        throw Exception('No se ha encontrado un carrito activo para el cliente');
      }

      final carritoId = carritoResponse.data['id'];

      // Vaciar el carrito
      final response = await _dio.delete('$baseUrl/carrito/vaciar/$carritoId');

      if (response.statusCode == 200) {
        print('Carrito vaciado con éxito');
      } else {
        print('Error al vaciar el carrito');
      }
    } catch (error) {
      throw Exception('Error al vaciar el carrito: $error');
    }
  }

  // Obtener los ítems del carrito activo
  // Obtener el carrito activo del cliente
  Future<String?> obtenerCarritoActivo(String clienteId) async {
    try {
      final response = await _dio.get('$baseUrl/api/carrito/$clienteId');
      if (response.statusCode == 200 && response.data != null) {
        return response.data['id']; // Devuelve el carritoId activo
      } else {
        return null;
      }
    } catch (error) {
      // throw Exception('Error al obtener el carrito activo: $error');
    }
  }

  // Obtener los ítems del carrito activo
  Future<List<dynamic>> obtenerItemsDelCarrito() async {
    final prefs = await SharedPreferences.getInstance();
    final clienteId = prefs.getString('cliente_id');

    if (clienteId == null) {
      throw Exception('No se ha encontrado el cliente');
    }

    try {
      // Obtener el carrito activo
      final carritoId = await obtenerCarritoActivo(clienteId);

      if (carritoId == null) {
        throw Exception('No se ha encontrado un carrito activo para este cliente');
      }

      // Obtener los ítems del carrito usando el carritoId
      final response = await _dio.get('$baseUrl/api/carrito/$carritoId/items');

      if (response.statusCode == 200) {
        return response.data; // Devuelve la lista de ítems del carrito
      } else {
        throw Exception('Error al obtener los items del carrito');
      }
    } catch (error) {
      throw Exception('Error al obtener los items del carrito: $error');
    }
  }
}
