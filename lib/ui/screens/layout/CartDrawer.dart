import 'package:flutter/material.dart';
import 'package:historial_medico_apk/services/AuthService.dart';
import 'package:historial_medico_apk/services/CarritoService.dart';

class CartDrawer extends StatefulWidget {
  @override
  _CartDrawerState createState() => _CartDrawerState();
}

class _CartDrawerState extends State<CartDrawer> {
  bool isLoading = true;
  List<Map<String, dynamic>> products = [];
  bool isEmpty = true;
  final CarritoService _carritoService = CarritoService(); // Instancia del servicio de carrito
  bool _isAuthenticated = false;
  final AuthService _authService = AuthService();
  @override
  void initState() {
    super.initState();
    _loadCartItems(); // Cargar los productos del carrito cuando el Drawer se abre
    _checkAuthentication();
  
  }
  void _checkAuthentication() async {
    bool isAuthenticated =await _authService.isAuthenticated();
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }
  Future<void> _loadCartItems() async {
    try {
      // Aquí llamas al servicio para obtener los productos del carrito
      final productosEnCarrito = await _carritoService.obtenerItemsDelCarrito();

      setState(() {
        products = productosEnCarrito.map((item) => {
          'name': item['producto']['nombre'],
          'price': item['precioUnitario'],
          'quantity': item['cantidad'],
          'image': item['producto']['imagenUrl'],
        }).toList();
        isEmpty = products.isEmpty;
        isLoading = false;
      });
    } catch (error) {
      print('Error al cargar el carrito: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85, // Ancho del carrito
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del carrito
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CARRITO',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el Drawer
                  },
                ),
              ],
            ),
          ),
          // Mostrar un indicador de carga mientras se cargan los productos
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            // Mostrar carrito vacío o con productos
            Expanded(
              child: isEmpty
                  ? _buildEmptyCart(context)
                  : _buildProductList(context),
            ),
          if (!isEmpty) _buildCheckoutSection(context),
        ],
      ),
    );
  }

  // Vista cuando el carrito está vacío
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Su carrito está vacío.',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              (_isAuthenticated)?
              Navigator.pushNamed(context, '/products'):
              Navigator.pushNamed(context, '/'); // Navegar a la pantalla de productos
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'EMPIEZA A COMPRAR',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

// Vista cuando hay productos en el carrito
Widget _buildProductList(BuildContext context) {
  return ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Bordes redondeados para la card
          ),
          elevation: 4, // Sombra alrededor de la card
          color: Colors.white, // Fondo blanco de la card
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Imagen del producto en el carrito con borde redondeado
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    product['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${product['price']} €',
                        style: const TextStyle(
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.pinkAccent),
                            onPressed: () {
                              // Lógica para reducir la cantidad
                            },
                          ),
                          Text('${product['quantity']}'),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.pinkAccent),
                            onPressed: () {
                              // Lógica para aumentar la cantidad
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              // Lógica para eliminar el producto del carrito
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}



 Widget _buildCheckoutSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Divider estilizado
        const Divider(
          thickness: 2,
          color: Colors.grey,
        ),
        const SizedBox(height: 12),
        
        // Texto de información de impuestos y envío
        const Text(
          'Impuesto incluido. Los gastos de envío se calculan en la pantalla de pago.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            height: 1.5, // Mejor legibilidad
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Checkbox y términos y condiciones
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (bool? value) {
                // Lógica para aceptar términos y condiciones
              },
              activeColor: Colors.pinkAccent, // Color personalizado para el checkbox
            ),
            const Expanded(
              child: Text(
                'Estoy de acuerdo con los términos y condiciones',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Botón de "PAGAR PEDIDO"
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/ventas');
            // Lógica para pagar el pedido
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Color del fondo del botón
            padding: const EdgeInsets.symmetric(vertical: 18), // Aumenta el padding vertical
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bordes más redondeados
            ),
            elevation: 5, // Sombra para dar un efecto elevado al botón
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.payment, color: Colors.white), // Icono de pago
              SizedBox(width: 8),
              Text(
                'PAGAR PEDIDO',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Color del texto
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}
