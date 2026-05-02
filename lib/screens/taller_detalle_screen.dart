import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class TallerDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> taller;

  const TallerDetalleScreen({super.key, required this.taller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      // Usamos un CustomScrollView para lograr un efecto visual muy atractivo al hacer scroll
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTaller(),
                  const SizedBox(height: 24),
                  const Text('Muro del Taller', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2128))),
                  const SizedBox(height: 12),
                  _buildMuroAnuncios(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. CABECERA CON IMAGEN (SliverAppBar) ---
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 220.0,
      pinned: true,
      backgroundColor: const Color(0xFF3F51B5),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(taller['nombre'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(taller['imagen_url'], fit: BoxFit.cover),
            // Un gradiente oscuro para que el texto resalte sobre la imagen
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. INFORMACIÓN DEL MAESTRO Y DETALLES ---
  Widget _buildInfoTaller() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue[100],
                child: const Icon(Icons.person, color: Color(0xFF3F51B5)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Maestro a cargo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(taller['maestro_nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 30),
          Text(taller['descripcion'], style: TextStyle(color: Colors.grey[700], fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  // --- 3. MURO DE ANUNCIOS (Conectado a SQLite) ---
  Widget _buildMuroAnuncios() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getAnunciosPorTaller(taller['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Aún no hay anuncios en este taller.', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          );
        }

        final anuncios = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true, // Importante cuando ListView está dentro de un SingleChildScrollView
          physics: const NeverScrollableScrollPhysics(), 
          padding: EdgeInsets.zero,
          itemCount: anuncios.length,
          itemBuilder: (context, index) {
            final anuncio = anuncios[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.campaign, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(anuncio['titulo'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        Text(anuncio['fecha'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(anuncio['contenido'], style: TextStyle(color: Colors.grey[800], height: 1.3)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
