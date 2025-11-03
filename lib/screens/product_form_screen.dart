import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/models/product_model.dart';
import 'package:flutter_hamburgesas/services/product_repository.dart';
import 'package:flutter_hamburgesas/widget/primary_action_button.dart';

class ProductFormScreen extends StatefulWidget {
  /// El producto a editar. Si es `null`, la pantalla estará en modo "Crear".
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productRepository = ProductRepository();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imagePathController;
  late String _selectedCategory;
  late int _selectedStatus;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.productName ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _imagePathController = TextEditingController(text: widget.product?.imagePath ?? 'assets/images/default.png');
    _selectedCategory = widget.product?.category ?? 'comida';
    _selectedStatus = widget.product?.idStatus ?? 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newProduct = Product(
      idProduct: widget.product?.idProduct, // Mantiene el ID si estamos editando
      productName: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      imagePath: _imagePathController.text,
      category: _selectedCategory,
      idStatus: _selectedStatus,
    );

    try {
      if (_isEditing) {
        await _productRepository.updateProduct(newProduct);
      } else {
        await _productRepository.insertProduct(newProduct);
      }

      if (mounted) {
        final message = _isEditing ? 'Producto actualizado con éxito' : 'Producto creado con éxito';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green[700]),
        );
        Navigator.of(context).pop(true); // Devuelve 'true' para indicar que se hizo un cambio
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el producto: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'EDITAR PRODUCTO' : 'AGREGAR PRODUCTO'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Nombre del Producto',
                icon: Icons.fastfood,
                validator: (value) => value == null || value.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _priceController,
                label: 'Precio',
                icon: Icons.attach_money,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'El precio es obligatorio';
                  if (double.tryParse(value) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _imagePathController,
                label: 'Ruta de la Imagen',
                icon: Icons.image,
                hint: 'Ej: assets/images/producto.png',
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: 'Categoría',
                value: _selectedCategory,
                items: ['comida', 'bebidas'],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedCategory = value);
                },
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: 'Estado',
                value: _selectedStatus,
                items: [
                  {'id': 1, 'name': 'Activo'},
                  {'id': 2, 'name': 'Archivado'},
                  {'id': 3, 'name': 'Sin Stock'},
                ],
                itemBuilder: (item) => DropdownMenuItem<int>(
                  value: item['id'] as int,
                  child: Text(item['name'] as String),
                ),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedStatus = value);
                },
              ),
              const SizedBox(height: 40),
              PrimaryActionButton(
                text: _isEditing ? 'GUARDAR CAMBIOS' : 'CREAR PRODUCTO',
                onPressed: _onSavePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<dynamic> items,
    required void Function(T?) onChanged,
    DropdownMenuItem<T> Function(dynamic)? itemBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: items.map<DropdownMenuItem<T>>((item) {
        if (itemBuilder != null) {
          return itemBuilder(item);
        }
        return DropdownMenuItem<T>(
          value: item as T,
          child: Text(item.toString().toUpperCase()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}