import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/screens/login_screen.dart'; 
import 'package:flutter_hamburgesas/screens/dashboard_order.dart';
import 'package:flutter_hamburgesas/services/order_service.dart';
import 'package:flutter_hamburgesas/widget/custom_app_bar.dart';
import 'package:flutter_hamburgesas/models/product_model.dart';
import 'package:flutter_hamburgesas/services/product_repository.dart';
import '../widget/order_summary_dialog.dart';
import '../widget/product_grid_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Instancia del repositorio de productos.
  final ProductRepository _productRepository = ProductRepository();
  // Instancia del nuevo servicio de órdenes.
  final OrderService _orderService = OrderService();

  // Listas para almacenar los productos obtenidos de la BD.
  List<Product> _comidas = [];
  List<Product> _bebidas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _orderService.addListener(_onOrderChanged);
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
    _orderService.removeListener(_onOrderChanged);
    _orderService.dispose();
    super.dispose();
  }

  // Listener para reconstruir la UI cuando la orden cambia.
  void _onOrderChanged() => setState(() {});

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
    _orderService.addToOrder(product);
    _showTopSnackBar('${product.productName} añadido a la orden.');
  }

  void _showOrderDialog() {
    if (_orderService.isEmpty) {
      _showTopSnackBar('Tu orden está vacía.', isError: true);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderSummaryDialog(
          orderItems: _orderService.orderItems,
          onUpdateItem: _orderService.updateOrderItem,
          onDeleteItem: _orderService.deleteOrderItem,
          onConfirmOrder: () {
            _orderService.clearOrder(); // Limpiamos la orden a través del servicio
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
        titleText: '',
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
      onSelected: (value) async { // 1. Convertir la función a async
        if (value == 'dashboard') {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
          // 3. Cuando regresemos, recargar los productos
          _loadProducts();
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
        final product = products[index];
        return ProductGridItem(
          product: product,
          onAddToCart: () => _addToOrder(product),
        );
      },
    );
  }
}
