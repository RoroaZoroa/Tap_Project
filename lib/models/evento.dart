class Evento {
  final int? id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String lugar;
  final String tipo;

  Evento({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.lugar,
    required this.tipo,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'fecha': fecha,
    'lugar': lugar,
    'tipo': tipo,
  };

  factory Evento.fromMap(Map<String, dynamic> map) => Evento(
    id: map['id'],
    titulo: map['titulo'],
    descripcion: map['descripcion'],
    fecha: map['fecha'],
    lugar: map['lugar'],
    tipo: map['tipo'],
  );
}
