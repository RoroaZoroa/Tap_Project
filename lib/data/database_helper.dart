import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/estudiante.dart';
import '../models/evento.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'itt_portal.db');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 4) {
      await db.execute('DROP TABLE IF EXISTS anuncios');
      await db.execute('DROP TABLE IF EXISTS inscripciones');
      await db.execute('DROP TABLE IF EXISTS grupos');
      await db.execute('DROP TABLE IF EXISTS talleres');
      await db.execute('DROP TABLE IF EXISTS eventos');
      await db.execute('DROP TABLE IF EXISTS alumnos');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla alumnos
    await db.execute('''
      CREATE TABLE alumnos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        num_control TEXT UNIQUE NOT NULL,
        nombre TEXT NOT NULL,
        carrera TEXT NOT NULL,
        semestre TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabla talleres (NUEVA ESTRUCTURA)
    await db.execute('''
      CREATE TABLE talleres (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        categoria TEXT NOT NULL, -- 'Deportivo' o 'Artístico'
        es_representativo INTEGER NOT NULL, -- 0 (No) o 1 (Sí)
        maestro_nombre TEXT NOT NULL,
        imagen_url TEXT NOT NULL
      )
    ''');

    // Tabla de Grupos (Horarios)
    await db.execute('''
      CREATE TABLE grupos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taller_id INTEGER NOT NULL,
        nombre_grupo TEXT NOT NULL, -- 'Grupo A' o 'Grupo B'
        horario TEXT NOT NULL, -- Ej: 'Lun y Mié 14:00-16:00'
        FOREIGN KEY (taller_id) REFERENCES talleres (id)
      )
    ''');

    // Tabla de Inscripciones (NUEVA ESTRUCTURA - Pivote a grupos)
    await db.execute('''
      CREATE TABLE inscripciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        grupo_id INTEGER NOT NULL,
        fecha_inscripcion TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES alumnos (id),
        FOREIGN KEY (grupo_id) REFERENCES grupos (id)
      )
    ''');

    // Tabla de Anuncios (El muro del taller)
    await db.execute('''
      CREATE TABLE anuncios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taller_id INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        contenido TEXT NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (taller_id) REFERENCES talleres (id)
      )
    ''');

    // Tabla eventos
    await db.execute('''
      CREATE TABLE eventos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        lugar TEXT NOT NULL,
        tipo TEXT NOT NULL
      )
    ''');

    // Seed data
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // Alumno demo
    await db.insert('alumnos', {
      'num_control': '23281337',
      'nombre': 'Sebastián Ballesteros Gutierrez',
      'carrera': 'Ingeniería en Sistemas Computacionales',
      'semestre': '4to Semestre',
      'email': '23281337@toluca.tecnm.mx',
      'password': 'PW104',
    });

    // -------- TALLERES SEED DATA --------

    // Lista de talleres normales para inyectar dinámicamente
    final talleresNormales = [
      // Artísticos
      {'nombre': 'Fotografía', 'cat': 'Artístico', 'maestro': 'Prof. Luis Mendoza'},
      {'nombre': 'Pintura', 'cat': 'Artístico', 'maestro': 'Mtra. Carmen Silva'},
      {'nombre': 'Ritmos Latinos', 'cat': 'Artístico', 'maestro': 'Prof. Hugo Sánchez'},
      {'nombre': 'Rondalla', 'cat': 'Artístico', 'maestro': 'Mtro. Carlos Rivera'},
      {'nombre': 'Tuna', 'cat': 'Artístico', 'maestro': 'Prof. Eduardo López'},
      {'nombre': 'Danza Folklórica', 'cat': 'Artístico', 'maestro': 'Prof. Alejandro Gómez'},
      // Deportivos
      {'nombre': 'Fútbol', 'cat': 'Deportivo', 'maestro': 'Coach Martín Torres'},
      {'nombre': 'Voleibol', 'cat': 'Deportivo', 'maestro': 'Mtra. Ana Gómez'},
      {'nombre': 'Karate', 'cat': 'Deportivo', 'maestro': 'Sensei Juan Pérez'},
      {'nombre': 'Hapki Do', 'cat': 'Deportivo', 'maestro': 'Sensei Miguel Soto'},
      {'nombre': 'Atletismo', 'cat': 'Deportivo', 'maestro': 'Coach Laura Flores'},
    ];

    // Iteramos para insertar cada taller y crearle 2 grupos automáticamente
    for (var t in talleresNormales) {
      int id = await db.insert('talleres', {
        'nombre': t['nombre'],
        'descripcion': 'Únete al taller de ${t['nombre']} y desarrolla tus habilidades.',
        'categoria': t['cat'],
        'es_representativo': 0,
        'maestro_nombre': t['maestro'],
        // Generamos una imagen aleatoria basada en el nombre para que no se repitan
        'imagen_url': 'https://picsum.photos/seed/${t['nombre'].toString().replaceAll(' ', '')}/400/200',
      });

      // Le asignamos 2 grupos a cada uno
      await db.insert('grupos', {'taller_id': id, 'nombre_grupo': 'Grupo A', 'horario': 'Lun y Mié 14:00-16:00'});
      await db.insert('grupos', {'taller_id': id, 'nombre_grupo': 'Grupo B', 'horario': 'Mar y Jue 16:00-18:00'});
    }

    // Un anuncio de prueba para cuando entres a alguno
    await db.insert('anuncios', {
      'taller_id': 1, // Se lo asignamos al primer taller (Fotografía)
      'titulo': '¡Bienvenidos al semestre!',
      'contenido': 'Recuerden traer su material básico para la primera sesión.',
      'fecha': '2026-03-16',
    });

    // -------- EVENTOS SEED DATA --------
    final eventos = [
      {
        'titulo': 'Semana de Ingeniería 2025',
        'descripcion':
            'Conferencias, talleres y expositores de las principales empresas tecnológicas del país.',
        'fecha': '2025-04-14',
        'lugar': 'Auditorio Principal',
        'tipo': 'Académico',
      },
      {
        'titulo': 'Expo Proyectos Integrador',
        'descripcion':
            'Presentación de proyectos integradores de todos los semestres. Votación pública para el mejor proyecto.',
        'fecha': '2025-05-20',
        'lugar': 'Edificio de Sistemas',
        'tipo': 'Académico',
      },
      {
        'titulo': 'Torneo Interfacultades de Fútbol',
        'descripcion':
            'Torneo anual entre departamentos. Inscripción de equipos abierta.',
        'fecha': '2025-04-05',
        'lugar': 'Cancha Principal',
        'tipo': 'Deportivo',
      },
    ];

    for (final evento in eventos) {
      await db.insert('eventos', evento);
    }
  }

  // ── ALUMNOS ──────────────────────────────────────────────
  Future<Estudiante?> login(String numControl, String password) async {
    final db = await database;
    final result = await db.query(
      'alumnos',
      where: 'num_control = ? AND password = ?',
      whereArgs: [numControl, password],
    );
    return result.isNotEmpty ? Estudiante.fromMap(result.first) : null;
  }

  Future<Estudiante?> getAlumno(int id) async {
    final db = await database;
    final result = await db.query('alumnos', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? Estudiante.fromMap(result.first) : null;
  }

  // ── TALLERES (NUEVOS MÉTODOS CRUD) ────────────────────────
  
  // Obtener todos los talleres
  Future<List<Map<String, dynamic>>> getTalleres() async {
    final db = await _instance.database;
    return await db.query('talleres');
  }

  // Obtener los grupos de un taller específico
  Future<List<Map<String, dynamic>>> getGruposPorTaller(int tallerId) async {
    final db = await _instance.database;
    return await db.query('grupos', where: 'taller_id = ?', whereArgs: [tallerId]);
  }

  // Inscribir alumno a un grupo (Usuario 1 quemado para el prototipo)
  Future<int> inscribirAlumno(int grupoId) async {
    final db = await _instance.database;
    return await db.insert('inscripciones', {
      'usuario_id': 1, 
      'grupo_id': grupoId,
      'fecha_inscripcion': DateTime.now().toIso8601String(),
    });
  }

  // Comprobar si ya está inscrito en un taller (haciendo un JOIN)
  Future<bool> estaInscritoEnTaller(int tallerId) async {
    final db = await _instance.database;
    final result = await db.rawQuery('''
      SELECT i.id FROM inscripciones i
      INNER JOIN grupos g ON i.grupo_id = g.id
      WHERE i.usuario_id = 1 AND g.taller_id = ?
    ''', [tallerId]);
    return result.isNotEmpty;
  }

  // ── EVENTOS ──────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getAnunciosPorTaller(int tallerId) async {
    final db = await _instance.database;
    return await db.query(
      'anuncios',
      where: 'taller_id = ?',
      whereArgs: [tallerId],
      orderBy: 'fecha DESC', // Para que los más nuevos salgan arriba
    );
  }

  Future<List<Evento>> getEventos() async {
    final db = await database;
    final result = await db.query('eventos', orderBy: 'fecha ASC');
    return result.map((e) => Evento.fromMap(e)).toList();
  }
}
