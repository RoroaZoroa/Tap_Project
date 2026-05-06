import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/database_helper.dart';
import '../models/evento.dart';

class AvisosScreen extends StatelessWidget {
  const AvisosScreen({super.key});

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
      body: FutureBuilder<List<Evento>>(
        future: DatabaseHelper().getEventos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No hay avisos recientes.',
                style: GoogleFonts.outfit(color: Colors.grey),
              ),
            );
          }

          final eventos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eventos.length,
            itemBuilder: (ctx, i) {
              final evento = eventos[i];
              return _AvisoCard(
                aviso: _Aviso(
                  titulo: evento.titulo,
                  cuerpo: evento.descripcion,
                  fecha: evento.fecha,
                  tipo: evento.tipo.toLowerCase(),
                ),
              );
            },
          );
        },
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
