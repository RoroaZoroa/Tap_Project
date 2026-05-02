import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  // Controlador para poder mover la cámara del mapa mediante botones
  final MapController _mapController = MapController();

  // Coordenadas aproximadas del Instituto Tecnológico de Toluca
  final LatLng _centroITT = const LatLng(19.2585, -99.5795);

  // Lista de Edificios (Marcadores)
  final List<Map<String, dynamic>> _edificios = [
    {
      'nombre': 'Edificio de Sistemas',
      'descripcion': 'Laboratorios de cómputo, aulas de Sistemas e Informática.',
      'ubicacion': const LatLng(19.2590, -99.5790),
      'icono': Icons.computer,
      'color': Colors.blue,
      'imagen': 'https://picsum.photos/seed/sistemas/400/200'
    },
    {
      'nombre': 'Edificio Administrativo',
      'descripcion': 'Servicios escolares, dirección y gestión financiera.',
      'ubicacion': const LatLng(19.2580, -99.5798),
      'icono': Icons.account_balance,
      'color': Colors.indigo,
      'imagen': 'https://picsum.photos/seed/admin/400/200'
    },
    {
      'nombre': 'Gimnasio Auditorio',
      'descripcion': 'Cancha principal de básquetbol y eventos institucionales.',
      'ubicacion': const LatLng(19.2575, -99.5785),
      'icono': Icons.sports_basketball,
      'color': Colors.orange,
      'imagen': 'https://picsum.photos/seed/gym/400/200'
    },
    {
      'nombre': 'Cafetería Principal',
      'descripcion': 'Zona de alimentos y convivencia estudiantil.',
      'ubicacion': const LatLng(19.2588, -99.5800),
      'icono': Icons.restaurant,
      'color': Colors.red,
      'imagen': 'https://picsum.photos/seed/cafe/400/200'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa del Campus'),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          _buildMapa(),
          _buildBotonCentrar(),
        ],
      ),
    );
  }

  // --- 1. EL WIDGET DEL MAPA ---
  Widget _buildMapa() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _centroITT,
        initialZoom: 17.5,
        maxZoom: 19.0,
        minZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.ittoluca.portal.estudiantil',
        ),
        MarkerLayer(
          markers: _edificios.map((edificio) {
            return Marker(
              point: edificio['ubicacion'],
              width: 60,
              height: 60,
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  _mapController.move(edificio['ubicacion'], 18.0);
                  _mostrarDetallesEdificio(edificio);
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: edificio['color'],
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Icon(edificio['icono'], color: Colors.white, size: 20),
                    ),
                    Icon(Icons.arrow_drop_down, color: edificio['color'], size: 20),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- 2. BOTÓN FLOTANTE PARA RE-CENTRAR ---
  Widget _buildBotonCentrar() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51B5),
        child: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () {
          _mapController.move(_centroITT, 17.5);
        },
      ),
    );
  }

  // --- 3. BOTTOM SHEET CON INFO DEL EDIFICIO ---
  void _mostrarDetallesEdificio(Map<String, dynamic> edificio) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  edificio['imagen'],
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: edificio['color'].withValues(alpha: 0.2), 
                    child: Icon(edificio['icono'], color: edificio['color']),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      edificio['nombre'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                edificio['descripcion'],
                style: TextStyle(color: theme.hintColor, fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
