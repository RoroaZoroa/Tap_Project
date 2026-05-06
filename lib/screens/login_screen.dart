import 'package:flutter/material.dart';
import 'main_screen.dart'; 
import '../models/estudiante.dart';
import '../data/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa tus datos')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final estudiante = await DatabaseHelper().login(
        _userController.text.trim(),
        _passController.text.trim(),
      );

      if (!mounted) return;

      if (estudiante != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(estudiante: estudiante)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Número de control o contraseña incorrectos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al conectar con la base de datos: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.only(top: 240.0),
                  child: _buildLoginCard(context),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              '© 2026 Instituto Tecnológico de Toluca\nTecNM',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 320,
      decoration: const BoxDecoration(
        color: Color(0xFF3F51B5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 70),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
            ),
            child: const Center(
              child: Text('ITT', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Instituto Tecnológico\nde Toluca',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Portal Estudiantil',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Iniciar Sesión',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa tus credenciales institucionales',
            style: TextStyle(color: theme.hintColor, fontSize: 13),
          ),
          const SizedBox(height: 24),
          
          TextField(
            controller: _userController,
            decoration: InputDecoration(
              hintText: 'Número de Control',
              prefixIcon: Icon(Icons.badge_outlined, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: _passController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Contraseña',
              prefixIcon: Icon(Icons.lock_outline, color: theme.colorScheme.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Ingresar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.blue),
                            SizedBox(width: 20),
                            Text('Conectando con Microsoft...', style: TextStyle(color: Colors.black87)),
                          ],
                        ),
                      ),
                    );
                  },
                );

                // 2. Esperar 2.5 segundos (Simulando la validación del token de Azure)
                Future.delayed(const Duration(milliseconds: 2500), () {
                  if (!mounted) return;
                  Navigator.pop(context); // Cierra el diálogo de carga
                  
                  final mockEstudiante = Estudiante(
                    nombre: 'Usuario Microsoft',
                    numControl: 'MSFT-2026',
                    carrera: 'Ingeniería en Sistemas',
                    semestre: '8vo Semestre',
                    email: 'microsoft.user@toluca.tecnm.mx',
                    password: 'azure-token-sim',
                  );

                  // Redirige al portal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen(estudiante: mockEstudiante)),
                  );
                });
              },
              icon: const Icon(Icons.window, color: Colors.blue), 
              label: Text('Continuar con Microsoft', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.dividerColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
