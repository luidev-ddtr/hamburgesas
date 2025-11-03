import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/widget/dialog_header.dart';

/// Un diálogo genérico para mostrar una lista de ítems y permitir la selección de uno.
class SelectionDialog<T> extends StatefulWidget {
  /// El título que se mostrará en el encabezado del diálogo.
  final String title;

  /// El ícono que se mostrará junto al título.
  final IconData icon;

  /// La lista de ítems a mostrar.
  final List<T> items;

  /// Una función que construye el widget para cada ítem de la lista.
  /// Recibe el ítem, si está seleccionado, y una función para manejar el tap.
  final Widget Function(T item, bool isSelected, VoidCallback onTap) itemBuilder;

  /// El texto para el botón de confirmación.
  final String confirmButtonText;

  /// La función que se ejecuta cuando se presiona el botón de confirmación.
  /// Recibe el ítem seleccionado.
  final Function(T selectedItem) onConfirm;

  const SelectionDialog({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    required this.itemBuilder,
    required this.confirmButtonText,
    required this.onConfirm,
  });

  @override
  State<SelectionDialog<T>> createState() => _SelectionDialogState<T>();
}

class _SelectionDialogState<T> extends State<SelectionDialog<T>> {
  T? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(
              icon: widget.icon,
              title: widget.title,
            ),
            const SizedBox(height: 20),
            const Divider(),
            if (widget.items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40.0),
                child: Text("No hay elementos para mostrar.", style: TextStyle(fontSize: 16, color: Colors.black54)),
              )
            else
              _buildItemList(),
            const SizedBox(height: 24),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 350),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final isSelected = _selectedItem == item;
          return widget.itemBuilder(item, isSelected, () {
            setState(() {
              _selectedItem = isSelected ? null : item;
            });
          });
        },
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedItem != null
            ? () {
                widget.onConfirm(_selectedItem as T);
                Navigator.of(context).pop(); // Cierra el diálogo después de confirmar
              }
            : null, // El botón está deshabilitado si no hay nada seleccionado
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF980101),
          disabledBackgroundColor: Colors.grey[400],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          widget.confirmButtonText,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: _selectedItem != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}