import 'package:cloud_firestore/cloud_firestore.dart';

class CloudHelper {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- ANUNCIOS (Muro de Talleres) ---
  
  // Obtener anuncios de un taller en tiempo real
  Stream<QuerySnapshot> streamAnuncios(int tallerId) {
    print('DEBUG CLOUD: Iniciando stream de anuncios para taller_id: $tallerId (tipo: ${tallerId.runtimeType})');
    return _db.collection('anuncios')
        .where('taller_id', isEqualTo: tallerId)
        .orderBy('fecha', descending: true)
        .snapshots();
  }

  // Agregar un anuncio nuevo
  Future<void> agregarAnuncio(int tallerId, String titulo, String contenido) async {
    await _db.collection('anuncios').add({
      'taller_id': tallerId,
      'titulo': titulo,
      'contenido': contenido,
      'fecha': DateTime.now().toIso8601String(),
    });
  }

  // --- COMENTARIOS ---

  // Obtener comentarios de un anuncio en tiempo real
  Stream<QuerySnapshot> streamComentarios(String anuncioDocId) {
    print('DEBUG CLOUD: Iniciando stream de comentarios para anuncio: $anuncioDocId');
    return _db.collection('anuncios')
        .doc(anuncioDocId)
        .collection('comentarios')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Agregar un comentario
  Future<void> agregarComentario(String anuncioDocId, String usuario, String texto) async {
    await _db.collection('anuncios')
        .doc(anuncioDocId)
        .collection('comentarios')
        .add({
      'usuario': usuario,
      'texto': texto,
      'hora': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'timestamp': FieldValue.serverTimestamp(),
      'es_maestro': 0,
    });
  }
}
