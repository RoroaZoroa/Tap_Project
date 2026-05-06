import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/cloud_helper.dart';
import '../models/estudiante.dart';

class TallerDetalleScreen extends StatefulWidget {
  final Map<String, dynamic> taller;
  final Estudiante estudiante;

  const TallerDetalleScreen({super.key, required this.taller, required this.estudiante});

  @override
  State<TallerDetalleScreen> createState() => _TallerDetalleScreenState();
}

class _TallerDetalleScreenState extends State<TallerDetalleScreen> {
  final TextEditingController _comentarioController = TextEditingController();
  final CloudHelper _cloud = CloudHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(widget.taller['nombre'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3F51B5),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _cloud.streamAnuncios(widget.taller['id']),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Error al cargar anuncios',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Es probable que falte un índice en Firestore. Revisa la consola de Firebase.\n\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.announcement_outlined, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No hay anuncios en este taller todavía.', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _cloud.agregarAnuncio(widget.taller['id'], '¡Bienvenidos!', 'Bienvenidos al nuevo muro en tiempo real.');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al crear anuncio: $e')),
                        );
                      }
                    },
                    child: const Text('Crear Primer Anuncio'),
                  )
                ],
              ),
            );
          }

          final anuncios = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: anuncios.length,
            itemBuilder: (context, index) {
              final anuncioDoc = anuncios[index];
              final anuncio = anuncioDoc.data() as Map<String, dynamic>;
              anuncio['doc_id'] = anuncioDoc.id; // Guardamos el ID del documento para los comentarios
              return _buildAnuncioCard(anuncio);
            },
          );
        },
      ),
    );
  }

  // Tarjeta de un Anuncio (El "Post")
  Widget _buildAnuncioCard(Map<String, dynamic> anuncio) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundColor: Color(0xFF3F51B5), child: Icon(Icons.person, color: Colors.white)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.taller['maestro_nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(anuncio['fecha'].toString().split('T')[0], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(anuncio['titulo'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF3F51B5))),
            const SizedBox(height: 6),
            Text(anuncio['contenido'], style: TextStyle(color: Colors.grey[800], height: 1.4)),
            const Divider(height: 30),
            // Botón para abrir los comentarios
            InkWell(
              onTap: () => _abrirSeccionComentarios(anuncio),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.comment_outlined, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text('Comentar en tiempo real', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cajón Inferior para los comentarios
  void _abrirSeccionComentarios(Map<String, dynamic> anuncio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Respuestas a: ${anuncio['titulo']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _cloud.streamComentarios(anuncio['doc_id']),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('DEBUG: Error en stream de comentarios: ${snapshot.error}');
                        return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(fontSize: 12, color: Colors.red)));
                      }

                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                      
                      final comentarios = snapshot.data!.docs;
                      if (comentarios.isEmpty) {
                        print('DEBUG: No hay comentarios para el doc: ${anuncio['doc_id']}');
                        return const Center(child: Text('Sé el primero en responder.'));
                      }

                      return ListView.builder(
                        itemCount: comentarios.length,
                        itemBuilder: (context, index) {
                          final com = comentarios[index].data() as Map<String, dynamic>;
                          final esMaestro = com['es_maestro'] == 1;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: esMaestro ? const Color(0xFF3F51B5) : Colors.grey[300],
                                  child: Text(com['usuario'][0], style: TextStyle(color: esMaestro ? Colors.white : Colors.black87, fontSize: 12)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: esMaestro ? Colors.blue[50] : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(com['usuario'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: esMaestro ? const Color(0xFF3F51B5) : Colors.black87)),
                                            Text(com['hora'] ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(com['texto'], style: const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Campo para escribir nuevo comentario
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _comentarioController,
                        decoration: InputDecoration(
                          hintText: 'Escribe una respuesta...',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF3F51B5)),
                      onPressed: () async {
                        if (_comentarioController.text.isNotEmpty) {
                          final texto = _comentarioController.text;
                          _comentarioController.clear();
                          await _cloud.agregarComentario(anuncio['doc_id'], widget.estudiante.nombre, texto);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

