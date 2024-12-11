import 'package:flutter/material.dart';
import 'package:historial_medico_apk/services/AuthService.dart';
import 'package:historial_medico_apk/ui/screens/layout/CartDrawer.dart';
import 'package:historial_medico_apk/utils/colors.dart';

class AppLayout extends StatefulWidget {
  final Widget child;

  const AppLayout({Key? key, required this.child}) : super(key: key);

  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isMenuOpen = false;
  bool _isSearching = false; // Nuevo estado para alternar la búsqueda
  TextEditingController _searchController = TextEditingController(); // Controlador de búsqueda
  bool _isAuthenticated = false;
  final AuthService _authService = AuthService(); // Instancia del servicio
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
        .animate(_animationController);
    _checkAuthentication();
    print('La autentificacion dio: $_isAuthenticated');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      if (_isMenuOpen) {
        _animationController.reverse(); // Cierra el menú
      } else {
        _animationController.forward(); // Abre el menú
      }
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _checkAuthentication() async {
    bool isAuthenticated =await _authService.isAuthenticated();
    setState(() {
      _isAuthenticated = isAuthenticated;
    });
  }

    // Función para cerrar sesión
  void _logout() async {
    // await AuthService().clearToken(); // Elimina el token almacenado
    _authService.logout();
    setState(() {
      _isAuthenticated = false; // Actualiza el estado a no autenticado
    });
    Navigator.pushNamed(context, '/login'); // Redirige al login después de cerrar sesión
  }
    // Función para manejar el botón de login
  void _login() {
    Navigator.pushNamed(context, '/login'); // Redirige a la pantalla de login
  }
  // Alternar el modo de búsqueda
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Limpiar búsqueda al salir
      }
    });
  }

    void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí puedes manejar las rutas dependiendo del índice seleccionado
    print(index);
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Navigator.pushNamed(context, '/appointments');
        break;
      case 2:
        Navigator.pushNamed(context, '/perfil');
        break;
      case 3:
        // Navigator.pushNamed(context, '/profile');
        break;
      case 4:
        // Navigator.pushNamed(context, '/profile');
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                onSubmitted: (query) {
                  print('Realizando búsqueda de: $query');
                  // Aquí puedes agregar la lógica para filtrar productos o hacer la búsqueda.
                },
              )
            : const Text(
                '',
                style: TextStyle(color: Colors.pinkAccent),
              ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close, // Icono animado hamburguesa/X
            progress: _animationController,
          ),
          onPressed: _toggleMenu, // Controla el abrir/cerrar el menú
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search), // Alternar entre búsqueda y cerrar
            onPressed: _toggleSearch, // Alternar modo búsqueda
          ),
          Builder(
            // Builder para crear un contexto adecuado para Scaffold.of
            
            builder: (context) => Stack(
  clipBehavior: Clip.none, // Permite que el contador sobresalga
  children: [
    IconButton(
      icon: const Icon(Icons.notifications, color: AppColors.primary),
      onPressed: () {
        Scaffold.of(context).openEndDrawer(); // Abre el Drawer desde el lado derecho
      },
    ),
    const Positioned(
      right: 10, // Ajusta la posición horizontal
      top: 10, // Ajusta la posición vertical
      child: CircleAvatar(
        radius: 8, // Tamaño del contador
        backgroundColor: Colors.red, // Color de fondo del contador
        child: Text(
          '5', // Cambia este número a la cantidad de notificaciones
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    ),
  ],
),
          ),
        ],
      ),
      endDrawer: CartDrawer(
        // isEmpty: true, // Controlar si el carrito está vacío o tiene productos
        // products: [], // Aquí puedes pasar la lista de productos en el carrito
      ),
      body: Stack(
        children: [
          // El contenido dinámico de la pantalla
          widget.child,

          // Oscurecimiento del fondo cuando el menú esté abierto
          _isMenuOpen
              ? GestureDetector(
                  onTap: _toggleMenu, // Al hacer clic fuera del menú, se cierra
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isMenuOpen ? 0.5 : 0.0, // Opacidad gradual
                    child: Container(
                      color: Colors.black, // Color de oscurecimiento
                    ),
                  ),
                )
              : Container(),

          // Menú personalizado deslizable
          SlideTransition(
            position: _slideAnimation, // Control de la animación
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75, // Menú con un 75% del ancho
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.black),
                    title: const Text(
                      'Inicio',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/products');
                      print('Inicio');
                      _toggleMenu(); // Cierra el menú al seleccionar una opción
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.new_releases, color: Colors.black),
                    title: const Text(
                      'Citas agendadas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      print('Nuevo presionado');
                      _toggleMenu(); // Cierra el menú al seleccionar una opción
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.checkroom, color: Colors.black),
                    title: const Text(
                      'Por prendas',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      print('Por prendas presionado');
                      _toggleMenu(); // Cierra el menú al seleccionar una opción
                    },
                  ),
                  const Divider(),
                  if(_isAuthenticated)// Mostrar solo si está autenticado
                    ListTile(
                      leading: const Icon(Icons.event, color: Colors.black),
                      title: const Text(
                        'Reservas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/reservas');
                        print('Por calzados presionado');
                        _toggleMenu(); // Cierra el menú al seleccionar una opción
                      },
                    ),
                  if (_isAuthenticated) const Divider(),
                  if(_isAuthenticated)// Mostrar solo si está autenticado
                    ListTile(
                      leading: const Icon(Icons.shopping_bag, color: Colors.black),
                      title: const Text(
                        'Compras',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/reservas');
                        print('Por calzados presionado');
                        _toggleMenu(); // Cierra el menú al seleccionar una opción
                      },
                    ),
                  if (_isAuthenticated) const Divider(),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Inicia sesion para poder hacer compras y otros beneficios.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_isAuthenticated) {
                          _logout(); // Llama a la función de logout si está autenticado
                        } else {
                          _login(); // Redirige al login si no está autenticado
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAuthenticated ? 
                        Colors.black : Colors.pinkAccent, // Cambia el color según el estado
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _isAuthenticated ? 'Cerrar sesión' : 'Inicia sesión', // Cambia el texto según el estado
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.insert_drive_file),
            label: 'Appointments',
          ),
          
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite, color: Colors.white, size: 30),
            ),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Ubicacion',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          
        ],
      ),
    );
  }
}
