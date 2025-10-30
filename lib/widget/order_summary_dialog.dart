import 'package:flutter/material.dart';
import 'edit_order_dialog.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un ítem individual para editar.'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    final selectedItem = widget.orderItems.firstWhere(
      (item) => item['id'] == _selectedItemId,
    );

    final result = await showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return EditOrderDialog(orderItem: selectedItem);
      },
    );

    if (result == 'delete') {
      widget.onDeleteItem(_selectedItemId!);
    } else if (result is Map<String, dynamic>) {
      widget.onUpdateItem(result);
    }

    if (mounted) {
      setState(() {
        _selectedItemId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in widget.orderItems) {
      String name = item['name'];
      if (!groupedItems.containsKey(name)) {
        groupedItems[name] = [];
      }
      groupedItems[name]!.add(item);
    }

    double subtotal = 0;
    for (var item in widget.orderItems) {
      final price = (item['price'] as num).toDouble();
      final quantity = (item['quantity'] as num).toInt();
      subtotal += price * quantity;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  color: const Color(0xFF980101),
                  size: 30,
                ),
                const SizedBox(width: 12),
                const Text(
                  'RESUMEN DE ORDEN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            if (widget.orderItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  "Tu orden está vacía",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: groupedItems.keys.length,
                  itemBuilder: (context, index) {
                    final groupName = groupedItems.keys.elementAt(index);
                    final itemsInGroup = groupedItems[groupName]!;
                    final bool isExpanded = _expandedGroupName == groupName;
                    return _buildGroupItem(groupName, itemsInGroup, isExpanded);
                  },
                ),
              ),
            const Divider(),
            const SizedBox(height: 20),
            Row(
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
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  label: 'EDITAR',
                  onPressed: _editSelectedItem,
                ),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  label: 'ELIMINAR',
                  onPressed: () {
                    if (_selectedItemId != null) {
                      widget.onDeleteItem(_selectedItemId!);
                      setState(() {
                        _selectedItemId = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Seleccione un ítem para eliminar.'),
                          backgroundColor: Colors.orangeAccent,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET MODIFICADO ---
  Widget _buildGroupItem(
    String name,
    List<Map<String, dynamic>> items,
    bool isExpanded,
  ) {
    // Se calcula la cantidad total del grupo sumando las cantidades individuales.
    final int totalQuantityInGroup = items.fold(
      0,
      (sum, item) => sum + (item['quantity'] as int),
    );

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expandedGroupName = isExpanded ? null : name;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: isExpanded ? Colors.red[50] : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${totalQuantityInGroup}x $name',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey[700],
                ),
              ],
            ),
          ),
        ),
        // Si el grupo está expandido, se muestra la lista detallada.
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(
              left: 24.0,
              top: 8.0,
              right: 8.0,
              bottom: 8.0,
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final int index = entry.key;
                final item = entry.value;
                final bool isSelected = _selectedItemId == item['id'];

                // Formatea los extras para que sean legibles.
                final extrasList = (item['extras'] as List<dynamic>?)
                    ?.map(
                      (e) => (e as String)
                          .replaceAll('_', ' ')
                          .split(' ')
                          .map(
                            (word) => word[0].toUpperCase() + word.substring(1),
                          )
                          .join(' '),
                    )
                    .toList();
                final String extrasString = extrasList?.isNotEmpty ?? false
                    ? 'Extras: ${extrasList!.join(', ')}'
                    : '';

                // Formatea las notas.
                final String notes = item['notes'] ?? '';
                final String notesString = notes.isNotEmpty
                    ? 'Notas: "$notes"'
                    : '';

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedItemId = isSelected ? null : item['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red[100] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Identificador numérico del pedido.
                        Text(
                          '${index + 1}. ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        // Columna para detalles del pedido.
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item['quantity']}x ${item['name']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              // Muestra los extras si existen.
                              if (extrasString.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    extrasString,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              // Muestra las notas si existen.
                              if (notesString.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    notesString,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black54),
      label: Text(label, style: const TextStyle(color: Colors.black54)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}
