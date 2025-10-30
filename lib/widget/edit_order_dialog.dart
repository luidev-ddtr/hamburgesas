import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necesario para el filtro de números

// --- LÓGICA DE DATOS PARA LOS PRODUCTOS ---
/// Una clase de utilidad estática para gestionar la lógica de negocio de los productos.
///
/// Centraliza la información sobre qué productos son bebidas y qué extras
/// corresponden a cada tipo de comida.
class ProductOptions {
  /// Lista estática para identificar qué productos se consideran bebidas.
  static const List<String> beverages = [
    'Refresco',
    'Jugo Natural',
    'Agua Fresca',
    'Delaware',
  ];

  /// Devuelve un mapa de extras relevantes para un [productName] específico.
  ///
  /// La lógica se basa en el nombre del producto para determinar qué extras ofrecer.
  static Map<String, Map<String, dynamic>> getExtrasFor(String productName) {
    if (productName.toLowerCase().contains('hamburguesa')) {
      return {
        'carne_doble': {'name': 'Carne doble', 'price': 20.0},
        'tocino_extra': {'name': 'Tocino Extra', 'price': 15.0},
        'aguacate': {'name': 'Aguacate', 'price': 15.0},
        'queso_extra': {'name': 'Queso Extra', 'price': 10.0},
      };
    }
    if (productName.toLowerCase().contains('alitas')) {
      return {
        'papas_fritas': {'name': 'Acompañado de Papas', 'price': 30.0},
        'salsa_habanero': {'name': 'Salsa Habanero Extra', 'price': 5.0},
      };
    }
    if (productName.toLowerCase().contains('papas')) {
      return {
        'queso_cheddar': {'name': 'Queso Cheddar', 'price': 15.0},
        'tocino_bits': {'name': 'Trocitos de Tocino', 'price': 10.0},
      };
    }
    // Devuelve un mapa vacío si el producto no tiene extras específicos.
    return {};
  }
}

// --- DIÁLOGO DE EDICIÓN ---
/// Un diálogo que permite al usuario modificar un ítem de la orden.
///
/// Permite cambiar la cantidad, añadir extras (si aplica) y dejar notas.
class EditOrderDialog extends StatefulWidget {
  /// El ítem de la orden que se va a editar.
  final Map<String, dynamic> orderItem;

  const EditOrderDialog({super.key, required this.orderItem});

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();
}

/// El estado para [EditOrderDialog].
class _EditOrderDialogState extends State<EditOrderDialog> {
  /// Controlador para el campo de texto de la cantidad.
  late TextEditingController _quantityController;

  /// Controlador para el campo de texto de las notas.
  late TextEditingController _notesController;

  /// Mapa que contiene los extras disponibles para el producto actual y su estado de selección.
  late Map<String, Map<String, dynamic>> _availableExtras;

  /// Bandera para determinar si el ítem es una bebida (y así simplificar la UI).
  late bool _isBeverage;

  /// Almacena el precio total calculado en tiempo real.
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos del ítem.
    _quantityController = TextEditingController(
      text: widget.orderItem['quantity'].toString(),
    );
    _notesController = TextEditingController(
      text: widget.orderItem['notes'] ?? '',
    );

    _isBeverage = ProductOptions.beverages.contains(widget.orderItem['name']);
    _availableExtras = ProductOptions.getExtrasFor(widget.orderItem['name']);

    // Marca como seleccionados los extras que ya venían en el ítem.
    if (widget.orderItem['extras'] != null) {
      for (var extraKey in widget.orderItem['extras']) {
        if (_availableExtras.containsKey(extraKey)) {
          _availableExtras[extraKey]!['selected'] = true;
        }
      }
    }

    // Añade un listener para recalcular el precio cada vez que cambia la cantidad.
    _quantityController.addListener(_calculateTotalPrice);
    // Calcula el precio inicial al abrir el diálogo.
    _calculateTotalPrice();
  }

  /// Calcula el precio total del ítem en tiempo real.
  ///
  /// Se basa en el precio base, los extras seleccionados y la cantidad.
  void _calculateTotalPrice() {
    double basePrice =
        (widget.orderItem['base_price'] as num? ??
                widget.orderItem['price'] as num)
            .toDouble();
    double extrasPrice = 0.0;
    int quantity = int.tryParse(_quantityController.text) ?? 0;

    _availableExtras.forEach((key, value) {
      if (value['selected'] == true) {
        extrasPrice += (value['price'] as num).toDouble();
      }
    });

    // Actualiza el estado para que la UI refleje el nuevo precio.
    setState(() {
      _totalPrice = (basePrice + extrasPrice) * quantity;
    });
  }

  @override
  void dispose() {
    // Es crucial remover el listener y desechar los controladores para liberar memoria.
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
              // --- Título del diálogo ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_note,
                    color: Color(0xFF980101),
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'EDITAR PRODUCTO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                widget.orderItem['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              // --- Muestra del Precio Total ---
              Text(
                '\$${_totalPrice.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF980101),
                ),
              ),
              const SizedBox(height: 16),

              // --- Campo de Texto para la Cantidad ---
              const Text(
                "Cantidad:",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Center(
                child: SizedBox(
                  width: 100, // Ancho fijo para el campo de cantidad.
                  child: TextFormField(
                    controller: _quantityController,
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
                    // Permite que solo se ingresen dígitos.
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),

              // --- Secciones condicionales para Extras y Notas ---
              // Solo se muestran si el producto NO es una bebida.
              if (!_isBeverage && _availableExtras.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Extras Disponibles:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                ..._availableExtras.entries.map((entry) {
                  final extra = entry.value;
                  return CheckboxListTile(
                    title: Text(extra['name']),
                    secondary: Text(
                      '+\$${(extra['price'] as num).toStringAsFixed(2)}',
                    ),
                    value: extra['selected'] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        extra['selected'] = value!;
                      });
                      _calculateTotalPrice(); // Recalcula el precio al cambiar un extra.
                    },
                    activeColor: const Color(0xFF980101),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
              ],
              if (!_isBeverage) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Notas Adicionales:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
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
              const SizedBox(height: 24),

              // --- Botones de Acción Finales ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(), // Cierra sin guardar.
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final quantity =
                          int.tryParse(_quantityController.text) ?? 0;
                      // Si la cantidad es 0, se interpreta como una eliminación.
                      if (quantity == 0) {
                        Navigator.of(context).pop('delete');
                        return;
                      }

                      // Prepara el mapa con los datos actualizados para devolverlo.
                      final updatedItem = Map<String, dynamic>.from(
                        widget.orderItem,
                      );

                      double basePrice =
                          (widget.orderItem['base_price'] as num? ??
                                  widget.orderItem['price'] as num)
                              .toDouble();
                      double extrasPrice = 0.0;
                      _availableExtras.forEach((key, value) {
                        if (value['selected'] == true) {
                          extrasPrice += (value['price'] as num).toDouble();
                        }
                      });

                      updatedItem['price'] = basePrice + extrasPrice;
                      updatedItem['base_price'] = basePrice;
                      updatedItem['quantity'] = quantity;

                      if (!_isBeverage) {
                        updatedItem['notes'] = _notesController.text;
                        updatedItem['extras'] = _availableExtras.entries
                            .where((e) => e.value['selected'] ?? false)
                            .map((e) => e.key)
                            .toList();
                      }
                      // Devuelve el ítem actualizado.
                      Navigator.of(context).pop(updatedItem);
                    },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
