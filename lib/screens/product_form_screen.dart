import 'package:flutter/material.dart';
import 'package:flutter_hamburgesas/models/product_model.dart';
import 'package:flutter_hamburgesas/services/product_repository.dart';
import 'package:flutter_hamburgesas/widget/primary_action_button.dart';
import 'dart:io';
import 'package:flutter_hamburgesas/services/add_picture/take_picture_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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

  Future<void> _takePicture() async {
    // Navega a la pantalla para tomar una foto y espera el resultado (la ruta de la imagen).
    final tempImagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const TakePictureScreen()),
    );

    // Si no se obtuvo una ruta de imagen temporal, no hacemos nada.
    if (tempImagePath == null || tempImagePath.isEmpty) return;

    try {
      // 1. Obtener el directorio de documentos de la aplicación, que es un lugar permanente.
      final appDir = await getApplicationDocumentsDirectory();
      // 2. Crear un nombre de archivo único para evitar colisiones.
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(tempImagePath)}';
      // 3. Crear la ruta de destino permanente.
      final permanentImagePath = p.join(appDir.path, fileName);
      // 4. Copiar el archivo desde la ruta temporal a la permanente.
      await File(tempImagePath).copy(permanentImagePath);

      // 5. Actualizar el controlador y la UI con la nueva ruta permanente.
      setState(() {
        _imagePathController.text = permanentImagePath;
      });
    } catch (e) {
      // Manejar cualquier error durante la copia del archivo.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar la imagen: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'EDITAR PRODUCTO' : 'AGREGAR PRODUCTO'),
        centerTitle: true,
       
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
              // Reemplazamos el campo de texto de la imagen por el nuevo widget de previsualización y captura.
              _buildImagePicker(),
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

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagen del Producto',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  // El ValueListenableBuilder reconstruye la imagen cuando cambia la ruta.
                  image: _imagePathController.text.startsWith('assets/')
                      ? AssetImage(_imagePathController.text) as ImageProvider
                      : FileImage(File(_imagePathController.text)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryActionButton(text: 'TOMAR FOTO', onPressed: _takePicture),
            ),
          ],
        ),
      ],
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