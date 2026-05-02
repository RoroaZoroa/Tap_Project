import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/estudiante.dart';

class ProfileScreen extends StatelessWidget {
  final Estudiante estudiante;
  final bool isTab;
  const ProfileScreen(
      {super.key, required this.estudiante, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0D2B6B),
            surfaceTintColor: Colors.transparent,
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D2B6B), Color(0xFF1565C0)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    isTab
                        ? CircleAvatar(
                            radius: 43,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: Center(
                              child: Text(
                                estudiante.nombre[0],
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                        : Hero(
                            tag: 'avatar',
                            child: Container(
                              width: 86,
                              height: 86,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  estudiante.nombre[0],
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      estudiante.nombre,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      estudiante.carrera,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chips de info
                  Row(
                    children: [
                      _Chip(
                        icon: Icons.badge_outlined,
                        label: estudiante.numControl,
                      ),
                      const SizedBox(width: 10),
                      _Chip(
                        icon: Icons.school_outlined,
                        label: estudiante.semestre,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Información Académica',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D2B6B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.person_outline,
                        label: 'Nombre completo',
                        value: estudiante.nombre,
                      ),
                      _InfoRow(
                        icon: Icons.badge_outlined,
                        label: 'Número de control',
                        value: estudiante.numControl,
                      ),
                      _InfoRow(
                        icon: Icons.school_outlined,
                        label: 'Carrera',
                        value: estudiante.carrera,
                      ),
                      _InfoRow(
                        icon: Icons.layers_outlined,
                        label: 'Semestre',
                        value: estudiante.semestre,
                      ),
                      _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Correo institucional',
                        value: estudiante.email,
                        last: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Institución',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D2B6B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.business_outlined,
                        label: 'Institución',
                        value: 'Instituto Tecnológico de Toluca',
                      ),
                      _InfoRow(
                        icon: Icons.account_balance_outlined,
                        label: 'Sistema',
                        value: 'TecNM - Tecnológico Nacional de México',
                      ),
                      _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Ciclo escolar',
                        value: '2024 - 2025',
                        last: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Preferencias
                  Text(
                    'Preferencias',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D2B6B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _InfoCard(
                    children: [
                      _SwitchRow(
                        icon: Icons.notifications_outlined,
                        label: 'Notificaciones de talleres',
                      ),
                      _SwitchRow(
                        icon: Icons.event_outlined,
                        label: 'Recordatorios de eventos',
                        last: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF1565C0)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D2B6B),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool last;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1565C0)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D2B6B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last)
          Divider(
            height: 1,
            indent: 46,
            endIndent: 16,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }
}

class _SwitchRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool last;
  const _SwitchRow({
    required this.icon,
    required this.label,
    this.last = false,
  });

  @override
  State<_SwitchRow> createState() => _SwitchRowState();
}

class _SwitchRowState extends State<_SwitchRow> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: const Color(0xFF1565C0)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0D2B6B),
                  ),
                ),
              ),
              Switch.adaptive(
                value: _enabled,
                activeColor: const Color(0xFF1565C0),
                onChanged: (v) => setState(() => _enabled = v),
              ),
            ],
          ),
        ),
        if (!widget.last)
          Divider(
            height: 1,
            indent: 46,
            endIndent: 16,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }
}
