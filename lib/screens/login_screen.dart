import 'package:flutter/material.dart';
import 'home_page_screen.dart'; // Asegúrate de que esta ruta de importación sea correcta
import '../widget/custom_app_bar.dart';
import '../widget/primary_action_button.dart';

// PÁGINA DE LOGIN REFACTORIZADA
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'REAL CAMPESTRE',
        actions: [_buildLoginMenu()],
      ),
      body: Stack(
        children: [
          // Elementos decorativos de fondo
          const _DecorativeCircle(top: -100, left: -100, radius: 250, opacity: 0.1),
          const _DecorativeCircle(bottom: -150, right: -100, radius: 400, opacity: 0.05),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuButton<String> _buildLoginMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'dashboard') {
          // Para este ejemplo, mostramos un mensaje. En una app real,
          // se verificaría si el usuario está logueado antes de navegar.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor, inicie sesión para acceder al panel.'),
              backgroundColor: Colors.orangeAccent,
            ),
          );
        }
        if (value == 'settings') {
          // Lógica para configuración
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'settings',
          child: Text('Configuración'),
        ),
        const PopupMenuItem<String>(
          value: 'dashboard',
          child: ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Panel de Control'),
          ),
        ),
      ],
      icon: const Icon(Icons.menu, size: 36),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const _LoginHeader(),
          const SizedBox(height: 40),
          _LoginInputField(
            label: 'Usuario:',
            controller: _userController,
            hintText: 'Ingrese su usuario',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese un usuario';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _LoginInputField(
            label: 'Contraseña:',
            controller: _passwordController,
            hintText: 'Ingrese su contraseña',
            isPassword: true,
            isPasswordVisible: _isPasswordVisible,
            onVisibilityToggle: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese una contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 50),
          PrimaryActionButton(
            text: 'Ingresar',
            onPressed: _onLoginPressed,
          ),
        ],
      ),
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      if (_userController.text == 'admin' && _passwordController.text == '123456') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}

// --- WIDGETS PRIVADOS PARA LOGIN_SCREEN ---

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'BIENVENIDO',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF980101),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Icon(
          Icons.person_pin_circle,
          color: Colors.red[300],
          size: 90.0,
        ),
      ],
    );
  }
}

class _LoginInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onVisibilityToggle;

  const _LoginInputField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : null,
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double? top, bottom, left, right;
  final double radius;
  final double opacity;

  const _DecorativeCircle({
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.radius,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
