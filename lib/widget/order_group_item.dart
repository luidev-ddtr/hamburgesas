import 'package:flutter/material.dart';
import '../models/order_dialog_model.dart';
import '../services/order_calculator_service.dart';

class OrderGroupItem extends StatelessWidget {
  final String groupName;
  final List<OrderItem> items;
  final bool isExpanded;
  final int? selectedItemId;
  final VoidCallback onGroupTap;
  final Function(int) onItemTap;

  const OrderGroupItem({
    super.key,
    required this.groupName,
    required this.items,
    required this.isExpanded,
    required this.selectedItemId,
    required this.onGroupTap, 
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuantity = OrderCalculatorService.calculateTotalQuantityForGroup(items);

    return Column(
      children: [
        _buildGroupHeader(totalQuantity),
        if (isExpanded) _buildExpandedList(),
      ],
    );
  }

  Widget _buildGroupHeader(int totalQuantity) {
    return InkWell(
      onTap: onGroupTap,
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
              '${totalQuantity}x $groupName',
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
    );
  }

  Widget _buildExpandedList() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        top: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = selectedItemId == item.id;

          return _buildOrderItem(item, index, isSelected);
        }).toList(),
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item, int index, bool isSelected) {
    final extrasString = OrderCalculatorService.formatExtras(item.extras);
    final notesString = OrderCalculatorService.formatNotes(item.notes);

    return InkWell(
      onTap: () => onItemTap(item.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.quantity}x ${item.name}',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
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
  }
}