import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'map_screen.dart';
import '../models/estudiante.dart';
import '../main.dart'; // Importamos el notificador global

class PerfilScreen extends StatelessWidget {
  final Estudiante estudiante;
  const PerfilScreen({super.key, required this.estudiante});

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
                  estudiante.nombre,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(estudiante.email, style: TextStyle(color: theme.hintColor, fontSize: 13)),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DirectorioScreen()),
            );
          },
        ),
        _buildOpcionItem(
          context: context,
          icono: Icons.health_and_safety_outlined,
          titulo: 'Seguro Social (IMSS)',
          subtitulo: 'Información de tu seguro facultativo',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SeguroSocialScreen()),
            );
          },
        ),
        _buildOpcionItem(
          context: context,
          icono: Icons.link,
          titulo: 'Enlaces Rápidos',
          subtitulo: 'Portal, Moodle, Biblioteca virtual',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EnlacesScreen()),
            );
          },
        ),
        _buildOpcionItem(
          context: context,
          icono: Icons.description_outlined,
          titulo: 'Términos y Privacidad',
          subtitulo: 'Aviso de privacidad del ITT',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TerminosScreen()),
            );
          },
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

// --- NUEVAS PANTALLAS INSTITUCIONALES ---

class DirectorioScreen extends StatelessWidget {
  const DirectorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final directorio = [
      {'depto': 'Conmutador Principal', 'numero': '722 208 7200', 'ext': ''},
      {'depto': 'División de Estudios Profesionales', 'numero': '722 208 7200', 'ext': 'Ext. 3101'},
      {'depto': 'Control Escolar', 'numero': '722 208 7200', 'ext': 'Ext. 3105'},
      {'depto': 'Centro de Información (Biblioteca)', 'numero': '722 208 7200', 'ext': 'Ext. 3110'},
      {'depto': 'Sistemas y Computación', 'numero': '722 208 7200', 'ext': 'Ext. 3115'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio ITT'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: directorio.length,
        itemBuilder: (context, index) {
          final item = directorio[index];
          return ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF3F51B5)),
            title: Text(item['depto']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${item['numero']} ${item['ext']}'),
            trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () {}),
          );
        },
      ),
    );
  }
}

class SeguroSocialScreen extends StatelessWidget {
  const SeguroSocialScreen({super.key});

  Future<void> _abrirVigenciaIMSS(BuildContext context) async {
    final Uri url = Uri.parse('https://serviciosdigitales.imss.gob.mx/gestionAsegurados-web-externo/vigencia');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo abrir la página')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seguro Facultativo'), backgroundColor: const Color(0xFF3F51B5), foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tu Número de Seguridad Social (NSS)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
              child: const Text('NSS: 8821-XX-XXXX', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ),
            const SizedBox(height: 24),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () => _abrirVigenciaIMSS(context),
                child: const Text('Descargar Vigencia de Derechos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EnlacesScreen extends StatelessWidget {
  const EnlacesScreen({super.key});

  Future<void> _abrirEnlace(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al abrir el enlace')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enlaces Rápidos'), backgroundColor: const Color(0xFF3F51B5), foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLinkCard(context, 'Portal Oficial ITT', 'Página principal del Tecnológico', Icons.web, 'https://toluca.tecnm.mx/'),
          _buildLinkCard(context, 'Moodle ITT', 'Plataforma de educación a distancia', Icons.menu_book, 'https://moodle.toluca.tecnm.mx/'),
          _buildLinkCard(context, 'Mindbox (SII)', 'Consulta de calificaciones y retícula', Icons.school, 'https://toluca.mindbox.app/login/alumno'),
        ],
      ),
    );
  }

  Widget _buildLinkCard(BuildContext context, String title, String subtitle, IconData icon, String url) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF3F51B5), size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => _abrirEnlace(context, url),
      ),
    );
  }
}

class TerminosScreen extends StatelessWidget {
  const TerminosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Términos y Privacidad'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del documento
              const Row(
                children: [
                  Icon(Icons.shield_outlined, size: 40, color: Color(0xFF3F51B5)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Aviso de Privacidad Integral',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2128)),
                    ),
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1),
              
              // Contenido
              _buildSeccion('1. Identidad y Domicilio', 
                'El Instituto Tecnológico de Toluca (ITT), con domicilio en Av. Tecnológico s/n, Agrícola Bellavista, Metepec, Edo. de México, es el responsable del tratamiento de los datos personales que nos proporcione, los cuales serán protegidos conforme a lo dispuesto por la Ley General de Protección de Datos Personales en Posesión de Sujetos Obligados.'),
              
              _buildSeccion('2. Finalidad de los datos', 
                'Sus datos personales serán utilizados para las siguientes finalidades:\n\n'
                '• Integrar su expediente académico.\n'
                '• Gestión de inscripciones a talleres y actividades extracurriculares.\n'
                '• Trámites de seguro facultativo (IMSS).\n'
                '• Generación de la credencial digital institucional.'),

              _buildSeccion('3. Transferencia de datos', 
                'Se informa que no se realizarán transferencias de datos personales, salvo aquéllas que sean necesarias para atender requerimientos de información de una autoridad competente, que estén debidamente fundados y motivados.'),

              _buildSeccion('4. Uso de la App (Prototipo)', 
                'Esta aplicación es un prototipo desarrollado para la materia de Tópicos Avanzados de Programación (TAP). Los datos generados en el módulo de SQLite residen únicamente en el almacenamiento local de este dispositivo.'),

              const SizedBox(height: 24),
              
              // Botón de confirmación
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para crear secciones de texto fácilmente
  Widget _buildSeccion(String titulo, String contenido) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E2128))),
          const SizedBox(height: 8),
          Text(
            contenido,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
