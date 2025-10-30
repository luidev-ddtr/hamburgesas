import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/screens/login_screen.dart'; // Asegúrate de que esta ruta sea correcta
import '../widget/order_summary_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _order = [];

  // Datos de ejemplo
  final List<Map<String, dynamic>> comidas = [
    {
      'name': 'Hamburguesa Clásica',
      'image': 'assets/images/Hamburguesa.jpg',
      'price': 85.00,
    },
    {
      'name': 'Alitas de Pollo BBQ',
      'image': 'assets/images/alitas_de_pollo.jpg',
      'price': 70.00,
    },
    {
      'name': 'Empanadas de Carne',
      'image': 'assets/images/empanadas.jpg',
      'price': 50.00,
    },
    {
      'name': 'Papas a la Francesa',
      'image': 'assets/images/papas_a_la_francesa.jpg',
      'price': 40.00,
    },
  ];

  final List<Map<String, dynamic>> bebidas = [
    {
      'name': 'Refresco de Cola',
      'image': 'assets/images/refresco.jpg',
      'price': 25.00,
    },
    {
      'name': 'Jugo de Naranja',
      'image': 'assets/images/jugo.jpg',
      'price': 30.00,
    },
    {
      'name': 'Agua de Horchata',
      'image': 'assets/images/agua.jpg',
      'price': 20.00,
    },
    {
      'name': 'Delaware Punch',
      'image': 'assets/images/cafe.jpg',
      'price': 25.00,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- FUNCIÓN MODIFICADA ---
  // Muestra un SnackBar en la parte superior de la pantalla.
  void _showTopSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        // Se define el comportamiento como "flotante" para poder moverlo.
        behavior: SnackBarBehavior.floating,
        // Margen inferior muy grande para empujarlo hacia arriba.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 180,
          left: 16,
          right: 16,
        ),
        backgroundColor: isError ? Colors.amber[800] : Colors.green[700],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToOrder(Map<String, dynamic> product) {
    setState(() {
      final uniqueId = DateTime.now().millisecondsSinceEpoch;
      _order.add({
        'id': uniqueId,
        'name': product['name'],
        'price': product['price'],
        // Se añade el precio base para consistencia con el diálogo de edición.
        'base_price': product['price'],
        'quantity': 1,
        'extras': [],
        'notes': '',
      });
      _showTopSnackBar('${product['name']} añadido a la orden.');
    });
  }

  void _updateOrderItem(Map<String, dynamic> updatedItem) {
    setState(() {
      final index = _order.indexWhere(
        (item) => item['id'] == updatedItem['id'],
      );
      if (index != -1) {
        _order[index] = updatedItem;
      }
    });
  }

  void _deleteOrderItem(int itemId) {
    setState(() {
      _order.removeWhere((item) => item['id'] == itemId);
    });
  }

  void _showOrderDialog() {
    if (_order.isEmpty) {
      _showTopSnackBar('Tu orden está vacía.', isError: true);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderSummaryDialog(
          orderItems: _order,
          onUpdateItem: _updateOrderItem,
          onDeleteItem: _deleteOrderItem,
        );
      },
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80.0,
        title: Row(
          children: [
            Image.asset('assets/images/Logo_campestre.jpg', height: 60),
            const SizedBox(width: 12),
            const Text('REAL CAMPESTRE'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Cerrar Sesión'),
              ),
            ],
            icon: const Icon(Icons.menu, size: 36),
          ),
          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF980101),
          indicatorWeight: 4.0,
          labelColor: const Color(0xFF980101),
          unselectedLabelColor: Colors.black54,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'COMIDAS'),
            Tab(text: 'BEBIDAS'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          TabBarView(
            controller: _tabController,
            children: [
              _buildProductGrid(comidas, crossAxisCount),
              _buildProductGrid(bebidas, crossAxisCount),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _showOrderDialog,
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'VER MI ORDEN',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF980101),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
    List<Map<String, dynamic>> products,
    int crossAxisCount,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildGridItem(product: products[index]);
      },
    );
  }

  Widget _buildGridItem({required Map<String, dynamic> product}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              product['image']!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.fastfood, color: Colors.grey, size: 60);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${(product['price'] as double).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    ),
                    InkWell(
                      onTap: () => _addToOrder(product),
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF980101),
                        child: Icon(Icons.add, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
