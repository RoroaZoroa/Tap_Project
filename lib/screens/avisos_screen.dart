import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});

  static final _avisos = [
    const _Aviso(
      titulo: '📅 Período de Inscripciones Abiertas',
      cuerpo:
          'Las inscripciones al semestre Agosto-Diciembre 2025 estarán abiertas del 14 al 28 de julio. Acude a ventanilla escolar o realízalas en línea.',
      fecha: 'Hace 2 días',
      tipo: 'importante',
    ),
    const _Aviso(
      titulo: '⚠️ Mantenimiento Plataforma SAES',
      cuerpo:
          'El sistema SAES estará fuera de servicio el sábado 8 de marzo de 12:00 AM a 6:00 AM por mantenimiento programado.',
      fecha: 'Hace 3 días',
      tipo: 'alerta',
    ),
    const _Aviso(
      titulo: '🏆 Convocatoria: Hackathon TecNM 2025',
      cuerpo:
          'Se abre la convocatoria para el Hackathon Nacional TecNM 2025. Equipos de 3-5 personas. Fecha límite de inscripción: 20 de marzo.',
      fecha: 'Hace 5 días',
      tipo: 'evento',
    ),
    const _Aviso(
      titulo: '📚 Nuevos Recursos en Biblioteca Digital',
      cuerpo:
          'Se han añadido más de 200 títulos de ingeniería y ciencias a la biblioteca digital institucional. Acceso con tus credenciales.',
      fecha: 'Hace 1 semana',
      tipo: 'info',
    ),
    const _Aviso(
      titulo: '🎓 Ceremonia de Titulación',
      cuerpo:
          'La próxima ceremonia de titulación está programada para el 15 de mayo. Los interesados deberán solicitar su expediente antes del 1ro de abril.',
      fecha: 'Hace 1 semana',
      tipo: 'evento',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0D2B6B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Avisos Institucionales',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D2B6B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _avisos.length,
        itemBuilder: (ctx, i) => _AvisoCard(aviso: _avisos[i]),
      ),
    );
  }
}

class _Aviso {
  final String titulo;
  final String cuerpo;
  final String fecha;
  final String tipo;
  const _Aviso({
    required this.titulo,
    required this.cuerpo,
    required this.fecha,
    required this.tipo,
  });
}

class _AvisoCard extends StatelessWidget {
  final _Aviso aviso;
  const _AvisoCard({required this.aviso});

  Color get _color => switch (aviso.tipo) {
    'importante' => const Color(0xFF1565C0),
    'alerta' => const Color(0xFFF57F17),
    'evento' => const Color(0xFF6A1B9A),
    _ => const Color(0xFF00897B),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border(left: BorderSide(color: _color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            aviso.titulo,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0D2B6B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            aviso.cuerpo,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            aviso.fecha,
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
