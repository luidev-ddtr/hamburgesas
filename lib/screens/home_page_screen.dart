import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/screens/login_screen.dart'; 
import 'package:flutter_hamburgesas/screens/dashboar_order.dart';
import 'package:flutter_hamburgesas/services/product_repository.dart';
import 'package:flutter_hamburgesas/widget/custom_app_bar.dart';
import 'package:flutter_hamburgesas/models/product_model.dart';
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

  // Instancia del repositorio de productos.
  final ProductRepository _productRepository = ProductRepository();

  // Listas para almacenar los productos obtenidos de la BD.
  List<Product> _comidas = [];
  List<Product> _bebidas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Usamos Future.wait para cargar ambas categorías en paralelo.
    final results = await Future.wait([
      _productRepository.getProductsByCategory('comida'),
      _productRepository.getProductsByCategory('bebidas'),
    ]);
    // print(results);
    // print("Hola desde flutter dart, puedo ver la info ? ");
    setState(() {
      _comidas = results[0];
      _bebidas = results[1];
      _isLoading = false;
    });
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

  void _addToOrder(Product product) {
    setState(() {
      final uniqueId = DateTime.now().millisecondsSinceEpoch;
      // La lógica de la orden (_order) sigue usando Map<String, dynamic>.
      // Convertimos el objeto Product a un mapa aquí.
      _order.add({
        'id': uniqueId,
        'id_product': product.idProduct, // <-- AÑADIDO: ID del producto para la BD
        'name': product.productName,
        'price': product.price,
        'base_price': product.price,
        'quantity': 1,
        'extras': [],
        'notes': '',
      });
      _showTopSnackBar('${product.productName} añadido a la orden.');
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
          onConfirmOrder: () {
            setState(() {
              _order.clear(); // Limpiamos la orden en la UI
            });
            Navigator.of(context).pop(); // Cerramos el diálogo
            _showTopSnackBar('¡Orden confirmada y enviada!', isError: false);
          },
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
      appBar: CustomAppBar(
        titleText: 'REAL CAMPESTRE',
        actions: [
          _buildHomeMenu(),
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
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF980101),
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProductGrid(_comidas, crossAxisCount),
                    _buildProductGrid(_bebidas, crossAxisCount),
                  ],
                ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _showOrderDialog,
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
                disabledBackgroundColor: Colors.grey,
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

  PopupMenuButton<String> _buildHomeMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'dashboard') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else if (value == 'logout') {
          _logout();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'dashboard',
          child: ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Panel de Control'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Cerrar Sesión'),
        ),
      ],
      icon: const Icon(Icons.menu, size: 36),
    );
  }

  Widget _buildProductGrid(
    List<Product> products,
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

  Widget _buildGridItem({required Product product}) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              product.imagePath?? 'assets/images/default.png',
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
                  product.productName,
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
                      '\$${product.price.toStringAsFixed(2)}',
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
