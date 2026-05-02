import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/database_helper.dart';
import '../models/evento.dart';

class EventosScreen extends StatelessWidget {
  const EventosScreen({super.key});

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
          'Eventos',
          style: GoogleFonts.outfit(
            color: const Color(0xFF0D2B6B),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder<List<Evento>>(
        future: DatabaseHelper().getEventos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final eventos = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eventos.length,
            itemBuilder: (ctx, i) => _EventoCard(evento: eventos[i]),
          );
        },
      ),
    );
  }
}

class _EventoCard extends StatelessWidget {
  final Evento evento;
  const _EventoCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    final isAcademico = evento.tipo == 'Académico';
    final color =
        isAcademico ? const Color(0xFF6A1B9A) : const Color(0xFFE53935);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                isAcademico ? '🎓' : '⚽',
                style: const TextStyle(fontSize: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.titulo,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D2B6B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  evento.descripcion,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      evento.fecha,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        evento.lugar,
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
