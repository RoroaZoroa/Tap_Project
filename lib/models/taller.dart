class Taller {
  final int? id;
  final String nombre;
  final String descripcion;
  final int cupoMax;
  final int cupoActual;
  final String horario;
  final String lugar;
  final String imagen; // emoji or asset name
  final String categoria;

  Taller({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.cupoMax,
    required this.cupoActual,
    required this.horario,
    required this.lugar,
    required this.imagen,
    required this.categoria,
  });

  int get cupoDisponible => cupoMax - cupoActual;
  bool get lleno => cupoDisponible <= 0;

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'cupo_max': cupoMax,
    'cupo_actual': cupoActual,
    'horario': horario,
    'lugar': lugar,
    'imagen': imagen,
    'categoria': categoria,
  };

  factory Taller.fromMap(Map<String, dynamic> map) => Taller(
    id: map['id'],
    nombre: map['nombre'],
    descripcion: map['descripcion'],
    cupoMax: map['cupo_max'],
    cupoActual: map['cupo_actual'],
    horario: map['horario'],
    lugar: map['lugar'],
    imagen: map['imagen'],
    categoria: map['categoria'],
  );
}
