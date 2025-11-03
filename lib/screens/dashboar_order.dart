import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/models/order_detail_model.dart';
import 'package:flutter_hamburgesas/models/view_order_model.dart';
import 'package:flutter_hamburgesas/services/order_repository.dart';
import 'package:flutter_hamburgesas/widget/custom_app_bar.dart';
import 'package:flutter_hamburgesas/widget/primary_action_button.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final OrderRepository _orderRepository = OrderRepository();
  late Future<List<DashboardOrder>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _ordersFuture = _orderRepository.getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'PANEL DE CONTROL',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 30),
            onPressed: _loadOrders,
            tooltip: 'Refrescar órdenes',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProductManagementSection(),
            const SizedBox(height: 24),
            const Divider(thickness: 1.5),
            const SizedBox(height: 16),
            _buildOrderHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gestión de Productos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PrimaryActionButton(
                text: 'AGREGAR',
                onPressed: () {
                  // TODO: Navegar a la pantalla de agregar producto
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad no implementada')),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryActionButton(
                text: 'ARCHIVAR',
                onPressed: () {
                  // TODO: Navegar a la pantalla de archivar producto
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad no implementada')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de Órdenes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<DashboardOrder>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF980101)));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error al cargar las órdenes: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('No hay órdenes registradas.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                ),
              );
            }

            final orders = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Para que funcione dentro de SingleChildScrollView
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildOrderCard(DashboardOrder order) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF980101),
          child: Text(
            order.idOrder.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          'Orden #${order.idOrder}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(DateFormat('dd/MM/yyyy, hh:mm a').format(order.orderDate)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${order.total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
            ),
            Text('${order.totalProducts} prod.', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        children: [
          _buildOrderDetails(order.idOrder),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(int orderId) {
    return FutureBuilder<List<OrderDetail>>(
      future: _orderRepository.getOrderDetails(orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3))),
          );
        }
        if (snapshot.hasError) {
          return const ListTile(title: Text('Error al cargar detalles.'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const ListTile(title: Text('No se encontraron productos para esta orden.'));
        }

        final details = snapshot.data!;
        return Container(
          color: Colors.grey[100],
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: details.map((detail) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(Icons.fastfood, color: Colors.black54, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        detail.productName,
                        style: const TextStyle(fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'x${detail.quantity}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}