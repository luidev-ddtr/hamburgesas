import 'package:flutter/material.dart';
import 'edit_order_dialog.dart';
import 'order_group_item.dart';
import 'order_action_button.dart';
import 'dialog_header.dart';
import '../models/order_dialog_model.dart';
import '../services/order_calculator_service.dart';

class OrderSummaryDialog extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final Function(Map<String, dynamic>) onUpdateItem;
  final Function(int) onDeleteItem;

  const OrderSummaryDialog({
    super.key,
    required this.orderItems,
    required this.onUpdateItem,
    required this.onDeleteItem,
  });

  @override
  State<OrderSummaryDialog> createState() => _OrderSummaryDialogState();
}

class _OrderSummaryDialogState extends State<OrderSummaryDialog> {
  int? _selectedItemId;
  String? _expandedGroupName;

  void _editSelectedItem() async {
    if (_selectedItemId == null) {
      _showSnackBar('Seleccione un ítem individual para editar.');
      return;
    }

    final selectedItem = widget.orderItems.firstWhere(
      (item) => item['id'] == _selectedItemId,
    );

    final result = await showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => EditOrderDialog(orderItem: selectedItem),
    );

    _handleEditResult(result);
  }

  void _handleEditResult(dynamic result) {
    if (result == 'delete') {
      widget.onDeleteItem(_selectedItemId!);
    } else if (result is Map<String, dynamic>) {
      widget.onUpdateItem(result);
    }

    if (mounted) {
      setState(() => _selectedItemId = null);
    }
  }

  void _deleteSelectedItem() {
    if (_selectedItemId != null) {
      widget.onDeleteItem(_selectedItemId!);
      setState(() => _selectedItemId = null);
    } else {
      _showSnackBar('Seleccione un ítem para eliminar.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderItems = widget.orderItems.map(OrderItem.fromMap).toList();
    final groupedItems = OrderCalculatorService.groupItemsByName(orderItems);
    final subtotal = OrderCalculatorService.calculateSubtotal(orderItems);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogHeader(
              icon: Icons.receipt_long,
              title: 'RESUMEN DE ORDEN',
            ),
            const SizedBox(height: 20),
            const Divider(),
            _buildOrderContent(orderItems, groupedItems, subtotal),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderContent(
    List<OrderItem> orderItems,
    Map<String, List<OrderItem>> groupedItems,
    double subtotal,
  ) {
    if (orderItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Text(
          "Tu orden está vacía",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return Column(
      children: [
        _buildOrderList(groupedItems),
        const Divider(),
        const SizedBox(height: 20),
        _buildSubtotal(subtotal),
        const SizedBox(height: 24),
        _buildActionButtons(),
        const SizedBox(height: 16),
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildOrderList(Map<String, List<OrderItem>> groupedItems) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 280),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: groupedItems.keys.length,
        itemBuilder: (context, index) {
          final groupName = groupedItems.keys.elementAt(index);
          final itemsInGroup = groupedItems[groupName]!;
          final isExpanded = _expandedGroupName == groupName;

          return OrderGroupItem(
            groupName: groupName,
            items: itemsInGroup,
            isExpanded: isExpanded,
            selectedItemId: _selectedItemId,
            onGroupTap: () {
              setState(() {
                _expandedGroupName = isExpanded ? null : groupName;
              });
            },
            onItemTap: (itemId) {
              setState(() {
                _selectedItemId = _selectedItemId == itemId ? null : itemId;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSubtotal(double subtotal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'SUBTOTAL:',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
        Text(
          '\$${subtotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OrderActionButton(
          icon: Icons.edit_outlined,
          label: 'EDITAR',
          onPressed: _editSelectedItem,
        ),
        OrderActionButton(
          icon: Icons.delete_outline,
          label: 'ELIMINAR',
          onPressed: _deleteSelectedItem,
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF980101),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'CONFIRMAR ORDEN',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}