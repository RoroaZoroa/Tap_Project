// lib/models/taller_model.dart

class Taller {
  final int? id;
  final String nombre;
  final String descripcion;
  final String horario;
  final String imagenUrl; // Para darle una vista moderna con imágenes
  bool inscrito; // Cambiará a true cuando el usuario se inscriba

  Taller({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.horario,
    required this.imagenUrl,
    this.inscrito = false,
  });

  // Método para convertir de Objeto a Map (Para insertar en SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'horario': horario,
      'imagenUrl': imagenUrl,
      'inscrito': inscrito ? 1 : 0, // SQLite no maneja booleanos, usa 1 y 0
    };
  }

  // Método para convertir de Map a Objeto (Para leer de SQLite)
  factory Taller.fromMap(Map<String, dynamic> map) {
    return Taller(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      horario: map['horario'],
      imagenUrl: map['imagenUrl'],
      inscrito: map['inscrito'] == 1,
    );
  }
}
