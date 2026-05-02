import 'package:flutter/material.dart';
import 'map_screen.dart';
import '../main.dart'; // Importamos el notificador global

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildResumenPerfil(context),
            const SizedBox(height: 24),
            
            // Sección de Apariencia
            _buildSeccionTitulo(context, 'Apariencia'),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (context, mode, _) {
                  return SwitchListTile(
                    title: const Text('Modo Oscuro', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Alternar entre tema claro y oscuro'),
                    secondary: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: theme.colorScheme.primary,
                    ),
                    value: mode == ThemeMode.dark,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (value) {
                      themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            _buildSeccionTitulo(context, 'Institucional'),
            _buildMenuOpciones(context),
            const SizedBox(height: 32),
            _buildBotonCerrarSesion(context),
            const SizedBox(height: 20),
            Text('Versión 1.0.0 (Prototipo TAP)', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionTitulo(BuildContext context, String titulo) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          titulo.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  // --- 1. CABECERA CON RESUMEN RÁPIDO ---
  Widget _buildResumenPerfil(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundImage: NetworkImage('https://picsum.photos/200'), 
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sebastián Ballesteros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text('sebas.ballesteros@toluca.tecnm.mx', style: TextStyle(color: theme.hintColor, fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: const Text('Estudiante Activo', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 2. LISTA DE OPCIONES ---
  Widget _buildMenuOpciones(BuildContext context) {
    return Column(
      children: [
        _buildOpcionItem(
          context: context,
          icono: Icons.map_outlined,
          titulo: 'Mapa del Campus',
          subtitulo: 'Ubicación de edificios y servicios',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapaScreen()),
            );
          },
        ),
        _buildOpcionItem(
          context: context,
          icono: Icons.contact_phone_outlined,
          titulo: 'Directorio Institucional',
          subtitulo: 'Números de contacto de departamentos',
          onTap: () {},
        ),
        _buildOpcionItem(
          context: context,
          icono: Icons.health_and_safety_outlined,
          titulo: 'Seguro Social (IMSS)',
          subtitulo: 'Información de tu seguro facultativo',
          onTap: () {},
        ),
        _buildOpcionItem(
          context: context,
          icono: Icons.link,
          titulo: 'Enlaces Rápidos',
          subtitulo: 'Portal, Moodle, Biblioteca virtual',
          onTap: () {},
        ),
        _buildOpcionItem(
          context: context,
          icono: Icons.description_outlined,
          titulo: 'Términos y Privacidad',
          subtitulo: 'Aviso de privacidad del ITT',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildOpcionItem({
    required BuildContext context,
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icono, color: theme.colorScheme.primary),
        ),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitulo, style: TextStyle(color: theme.hintColor, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildBotonCerrarSesion(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sesión cerrada correctamente')),
          );
        },
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
