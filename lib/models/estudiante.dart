class Estudiante {
  final int? id;
  final String numControl;
  final String nombre;
  final String carrera;
  final String semestre;
  final String email;
  final String password;

  Estudiante({
    this.id,
    required this.numControl,
    required this.nombre,
    required this.carrera,
    required this.semestre,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'num_control': numControl,
        'nombre': nombre,
        'carrera': carrera,
        'semestre': semestre,
        'email': email,
        'password': password,
      };

  factory Estudiante.fromMap(Map<String, dynamic> map) => Estudiante(
        id: map['id'],
        numControl: map['num_control'],
        nombre: map['nombre'],
        carrera: map['carrera'],
        semestre: map['semestre'],
        email: map['email'],
        password: map['password'],
      );
}
