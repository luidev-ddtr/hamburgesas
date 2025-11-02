import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dialog_header.dart';

// --- LÓGICA DE DATOS PARA LOS PRODUCTOS ---
class ProductOptions {
  static const List<String> beverages = [
    'Refresco',
    'Jugo Natural',
    'Agua Fresca',
    'Delaware',
  ];

  /// Devuelve un mapa que asocia el nombre de un extra con su precio,
  /// dado el nombre de un producto. Los extras se pueden agregar
  /// en función del nombre del producto.
  ///
  /// Se devuelve un mapa vacío si el nombre del producto no coincide con
  /// ninguno de los siguientes patrones:
  /// - 'hamburguesa' para devolver los extras de una hamburguesa.
  /// - 'alitas' para devolver los extras de una alita.
  /// - 'papas' para devolver los extras de una papa.
  ///
  /// El mapa devuelto tiene la siguiente estructura:
  /// {
  ///   'nombre_extra': {'name': 'nombre del extra', 'price': precio},
  ///   ...
  /// }
  static Map<String, Map<String, dynamic>> getExtrasFor(String productName) {
    final name = productName.toLowerCase();
    
    if (name.contains('hamburguesa')) {
      return _createExtrasMap({
        'carne_doble': {'name': 'Carne doble', 'price': 20.0},
        'tocino_extra': {'name': 'Tocino Extra', 'price': 15.0},
        'aguacate': {'name': 'Aguacate', 'price': 15.0},
        'queso_extra': {'name': 'Queso Extra', 'price': 10.0},
      });
    }
    if (name.contains('alitas')) {
      return _createExtrasMap({
        'papas_fritas': {'name': 'Acompañado de Papas', 'price': 30.0},
        'salsa_habanero': {'name': 'Salsa Habanero Extra', 'price': 5.0},
      });
    }
    if (name.contains('papas')) {
      return _createExtrasMap({
        'queso_cheddar': {'name': 'Queso Cheddar', 'price': 15.0},
        'tocino_bits': {'name': 'Trocitos de Tocino', 'price': 10.0},
      });
    }
    
    return {};
  }

/// Crea una copia inmutable de un mapa de opciones de producto.
///
/// [extras] es un mapa cuyas claves son los nombres de las opciones y cuyos valores son mapas con la informaci n de dicha opci n.
///
/// Retorna un mapa inmutable con las mismas claves y valores que [extras].
///
/// Este m todo es til para asegurar que no se modifiquen accidentalmente el mapa de opciones de un producto.
  static Map<String, Map<String, dynamic>> _createExtrasMap(
      Map<String, Map<String, dynamic>> extras) {
    return Map.from(extras);
  }
}

// --- COMPONENTES DE UI ---
class _DialogHeader extends StatelessWidget {
  final String productName;
  final double totalPrice;

  const _DialogHeader({
    required this.productName,
    required this.totalPrice,
  });

  @override

  Widget build(BuildContext context) {
    return Column(
      children: [
        const DialogHeader(
          icon: Icons.edit_note,
          title: 'EDITAR PRODUCTO',
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        Text(
          productName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '\$${totalPrice.toStringAsFixed(2)}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF980101),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _QuantityInput extends StatelessWidget {
  final TextEditingController controller;

  const _QuantityInput({required this.controller});

  @override
/// Returns a Column widget containing a Text widget with the label
/// "Cantidad:", a SizedBox with a height of 8 and a TextFormField
/// widget with the given controller.
///
/// The TextFormField widget is centered and has a width of 100. It
/// also has a decoration with a circular border and a number
/// keyboard. The input formatters are set to only allow
/// digits to be entered.
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Cantidad:",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 8),
        Center(
          child: SizedBox(
            width: 100,
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExtrasSection extends StatelessWidget {
  final Map<String, Map<String, dynamic>> availableExtras;
  final VoidCallback onExtraChanged;

  const _ExtrasSection({
    required this.availableExtras,
    required this.onExtraChanged,
  });

  @override
/// Builds a column with a divider and a title, followed by a list of
/// checkboxes representing the available extras.
///
/// Each checkbox is labeled with the name of the extra and its price.
/// The value of the checkbox is stored in the 'selected' key of the extra's
/// map. When the value of the checkbox changes, the [onExtraChanged] callback
/// is called.
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'Extras Disponibles:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...availableExtras.entries.map((entry) {
          final extra = entry.value;
          return CheckboxListTile(
            title: Text(extra['name']),
            secondary: Text(
              '+\$${(extra['price'] as num).toStringAsFixed(2)}',
            ),
            value: extra['selected'] ?? false,
            onChanged: (bool? value) {
              extra['selected'] = value!;
              onExtraChanged();
            },
            activeColor: const Color(0xFF980101),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  final TextEditingController controller;

  const _NotesSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 16),
        const Text(
          'Notas Adicionales:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Ej: Sin cebolla, bien cocido, etc.',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _ActionButtons({
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF980101),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Guardar Cambios',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

// --- DIÁLOGO PRINCIPAL ---
class EditOrderDialog extends StatefulWidget {
  final Map<String, dynamic> orderItem;

  const EditOrderDialog({super.key, required this.orderItem});

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _notesController;
  late Map<String, Map<String, dynamic>> _availableExtras;
  late bool _isBeverage;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeProductData();
    _quantityController.addListener(_calculateTotalPrice);
    _calculateTotalPrice();
  }

  void _initializeControllers() {
    _quantityController = TextEditingController(
      text: widget.orderItem['quantity'].toString(),
    );
    _notesController = TextEditingController(
      text: widget.orderItem['notes'] ?? '',
    );
  }

  void _initializeProductData() {
    _isBeverage = ProductOptions.beverages.contains(widget.orderItem['name']);
    _availableExtras = ProductOptions.getExtrasFor(widget.orderItem['name']);
    _markExistingExtras();
  }

  void _markExistingExtras() {
    if (widget.orderItem['extras'] != null) {
      for (var extraKey in widget.orderItem['extras']) {
        if (_availableExtras.containsKey(extraKey)) {
          _availableExtras[extraKey]!['selected'] = true;
        }
      }
    }
  }

  void _calculateTotalPrice() {
    final basePrice = _getBasePrice();
    final extrasPrice = _calculateExtrasPrice();
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    setState(() {
      _totalPrice = (basePrice + extrasPrice) * quantity;
    });
  }

  double _getBasePrice() {
    return (widget.orderItem['base_price'] as num? ?? 
            widget.orderItem['price'] as num).toDouble();
  }

  double _calculateExtrasPrice() {
    double extrasPrice = 0.0;
    _availableExtras.forEach((key, value) {
      if (value['selected'] == true) {
        extrasPrice += (value['price'] as num).toDouble();
      }
    });
    return extrasPrice;
  }

  void _onSavePressed() {
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    
    if (quantity == 0) {
      Navigator.of(context).pop('delete');
      return;
    }

    final updatedItem = _createUpdatedItem(quantity);
    Navigator.of(context).pop(updatedItem);
  }

  Map<String, dynamic> _createUpdatedItem(int quantity) {
    final updatedItem = Map<String, dynamic>.from(widget.orderItem);
    final basePrice = _getBasePrice();
    final extrasPrice = _calculateExtrasPrice();

    updatedItem['price'] = basePrice + extrasPrice;
    updatedItem['base_price'] = basePrice;
    updatedItem['quantity'] = quantity;

    if (!_isBeverage) {
      updatedItem['notes'] = _notesController.text;
      updatedItem['extras'] = _getSelectedExtras();
    }

    return updatedItem;
  }

  List<String> _getSelectedExtras() {
    return _availableExtras.entries
        .where((e) => e.value['selected'] ?? false)
        .map((e) => e.key)
        .toList();
  }

  @override
  void dispose() {
    _quantityController.removeListener(_calculateTotalPrice);
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DialogHeader(
                productName: widget.orderItem['name'],
                totalPrice: _totalPrice,
              ),
              
              _QuantityInput(controller: _quantityController),

              if (!_isBeverage && _availableExtras.isNotEmpty) 
                _ExtrasSection(
                  availableExtras: _availableExtras,
                  onExtraChanged: _calculateTotalPrice,
                ),

              if (!_isBeverage) 
                _NotesSection(controller: _notesController),

              const SizedBox(height: 24),
              
              _ActionButtons(
                onCancel: () => Navigator.of(context).pop(),
                onSave: _onSavePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}