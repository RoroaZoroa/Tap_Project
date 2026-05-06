import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/estudiante.dart';
import 'tabs/calificaciones_tab.dart';
import 'tabs/carga_tab.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  final Estudiante estudiante;
  const HomeScreen({super.key, required this.estudiante});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            FlipCard(
              key: cardKey,
              flipOnTouch: false,
              direction: FlipDirection.HORIZONTAL,
              front: _buildFrontCard(context),
              back: _buildBackCard(context),
            ),
            const SizedBox(height: 20),
            _buildTabsSection(context),
          ],
        ),
      ),
    );
  }

  // --- CARA FRONTAL ---
  Widget _buildFrontCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
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
      child: Column(
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage('https://picsum.photos/200'),
          ),
          const SizedBox(height: 16),
          Text(
            widget.estudiante.nombre.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.estudiante.carrera} - ${widget.estudiante.semestre}',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.hintColor, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => cardKey.currentState?.toggleCard(),
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            label: const Text('Mostrar Credencial', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F51B5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // --- CARA TRASERA (Código QR) ---
  Widget _buildBackCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'ESCANEA PARA ACCESO',
            style: TextStyle(color: theme.colorScheme.primary, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco SIEMPRE para códigos QR
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: widget.estudiante.numControl, 
              version: QrVersions.auto,
              size: 150.0,
            ),
          ),
          const SizedBox(height: 16),
          Text('Vigencia: Ciclo 2026', style: TextStyle(color: theme.hintColor, fontSize: 13)),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => cardKey.currentState?.toggleCard(),
            icon: const Icon(Icons.flip_to_front),
            label: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  // --- SECCIÓN DE PESTAÑAS Y TABLAS ---
  Widget _buildTabsSection(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Container(
        height: 450,
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
        child: Column(
          children: [
            TabBar(
              indicatorColor: theme.colorScheme.primary,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.hintColor,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Bienvenido'),
                Tab(text: 'Calificaciones'),
                Tab(text: 'Carga'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBienvenidoTab(context),
                  CalificacionesTab(alumnoId: widget.estudiante.id ?? 1),
                  const CargaTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBienvenidoTab(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.2)), 
          const SizedBox(height: 16),
          Text(
            'INSTITUTO TECNOLÓGICO DE TOLUCA',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Portal del Estudiante',
            style: TextStyle(color: theme.hintColor),
          ),
          const SizedBox(height: 30),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapaScreen()),
              );
            },
            icon: const Icon(Icons.map_rounded),
            label: const Text('Explorar Campus'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
