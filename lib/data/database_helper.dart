import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/estudiante.dart';
import '../models/evento.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Forzamos la ruta absoluta a tu carpeta de proyecto para sincronización total
      path = r'C:\Users\sebas\OneDrive\Documentos\TAP_Proyecto\itt_portal.db';
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'itt_portal.db');
    }
    
    return await openDatabase(
      path,
      version: 8, // Incrementamos para agregar segundo usuario
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS comentarios');
      await db.execute('DROP TABLE IF EXISTS anuncios');
      await db.execute('DROP TABLE IF EXISTS inscripciones');
      await db.execute('DROP TABLE IF EXISTS grupos');
      await db.execute('DROP TABLE IF EXISTS talleres');
      await db.execute('DROP TABLE IF EXISTS eventos');
      await db.execute('DROP TABLE IF EXISTS alumnos');
      await db.execute('DROP TABLE IF EXISTS calificaciones');
      await db.execute('DROP TABLE IF EXISTS materias');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla alumnos
    await db.execute('''
      CREATE TABLE IF NOT EXISTS alumnos (
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
      CREATE TABLE IF NOT EXISTS talleres (
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
      CREATE TABLE IF NOT EXISTS grupos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taller_id INTEGER NOT NULL,
        nombre_grupo TEXT NOT NULL, -- 'Grupo A' o 'Grupo B'
        horario TEXT NOT NULL, -- Ej: 'Lun y Mié 14:00-16:00'
        FOREIGN KEY (taller_id) REFERENCES talleres (id)
      )
    ''');
 
    // Tabla de Inscripciones (NUEVA ESTRUCTURA - Pivote a grupos)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS inscripciones (
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
      CREATE TABLE IF NOT EXISTS anuncios (
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
      CREATE TABLE IF NOT EXISTS eventos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        lugar TEXT NOT NULL,
        tipo TEXT NOT NULL
      )
    ''');
 
    // Tabla materias
    await db.execute('''
      CREATE TABLE IF NOT EXISTS materias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clave TEXT UNIQUE NOT NULL,
        nombre TEXT NOT NULL,
        creditos INTEGER NOT NULL,
        horario_completo TEXT -- Ej: 'Lun|07:00-08:40|S-201;Mie|07:00-08:40|S-201'
      )
    ''');
 
    // Tabla calificaciones
    await db.execute('''
      CREATE TABLE IF NOT EXISTS calificaciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alumno_id INTEGER NOT NULL,
        materia_id INTEGER NOT NULL,
        u1 INTEGER,
        u2 INTEGER,
        u3 INTEGER,
        u4 INTEGER,
        u5 INTEGER,
        u6 INTEGER,
        periodo TEXT NOT NULL,
        FOREIGN KEY (alumno_id) REFERENCES alumnos (id),
        FOREIGN KEY (materia_id) REFERENCES materias (id)
      )
    ''');
 
    // Tabla de Comentarios de los Anuncios
    await db.execute('''
      CREATE TABLE IF NOT EXISTS comentarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anuncio_id INTEGER NOT NULL,
        usuario TEXT NOT NULL,
        texto TEXT NOT NULL,
        hora TEXT NOT NULL,
        es_maestro INTEGER NOT NULL,
        FOREIGN KEY (anuncio_id) REFERENCES anuncios (id)
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
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    await db.insert('alumnos', {
      'num_control': '23281000',
      'nombre': 'María García Pérez',
      'carrera': 'Ingeniería Industrial',
      'semestre': '2do Semestre',
      'email': '23281000@toluca.tecnm.mx',
      'password': 'demo',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    // -------- TALLERES SEED DATA --------
    final talleresNormales = [
      {'nombre': 'Fotografía', 'cat': 'Artístico', 'maestro': 'Prof. Luis Mendoza'},
      {'nombre': 'Pintura', 'cat': 'Artístico', 'maestro': 'Mtra. Carmen Silva'},
      {'nombre': 'Ritmos Latinos', 'cat': 'Artístico', 'maestro': 'Prof. Hugo Sánchez'},
      {'nombre': 'Fútbol', 'cat': 'Deportivo', 'maestro': 'Coach Martín Torres'},
      {'nombre': 'Karate', 'cat': 'Deportivo', 'maestro': 'Sensei Juan Pérez'},
    ];

    for (var t in talleresNormales) {
      int tId = await db.insert('talleres', {
        'nombre': t['nombre'],
        'descripcion': 'Desarrolla tu talento en el taller de ${t['nombre']}.',
        'categoria': t['cat'],
        'es_representativo': 0,
        'maestro_nombre': t['maestro'],
        'imagen_url': 'https://picsum.photos/seed/${t['nombre']}/400/200',
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      if (tId > 0) {
        // Solo insertamos grupos y anuncios si el taller es nuevo
        int gIdA = await db.insert('grupos', {'taller_id': tId, 'nombre_grupo': 'Grupo A', 'horario': 'Lun y Mié 14:00-16:00'}, conflictAlgorithm: ConflictAlgorithm.ignore);
        await db.insert('grupos', {'taller_id': tId, 'nombre_grupo': 'Grupo B', 'horario': 'Mar y Jue 16:00-18:00'}, conflictAlgorithm: ConflictAlgorithm.ignore);

        int aId = await db.insert('anuncios', {
          'taller_id': tId,
          'titulo': '¡Bienvenidos al taller de ${t['nombre']}!',
          'contenido': 'Hola a todos. Iniciamos actividades la próxima semana.',
          'fecha': '2025-03-05',
        }, conflictAlgorithm: ConflictAlgorithm.ignore);

        if (aId > 0) {
          await db.insert('comentarios', {
            'anuncio_id': aId,
            'usuario': 'Sebastián (Tú)',
            'texto': '¡Excelente! Ahí estaré puntual.',
            'hora': '10:30',
            'es_maestro': 0,
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }

        if (t['nombre'] == 'Fotografía' || t['nombre'] == 'Fútbol') {
          await db.insert('inscripciones', {
            'usuario_id': 1,
            'grupo_id': gIdA,
            'fecha_inscripcion': '2025-02-15',
          }, conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
    }

    // -------- EVENTOS SEED DATA --------
    final eventos = [
      {'titulo': 'Semana de Ingeniería 2025', 'descripcion': 'Conferencias magistrales.', 'fecha': '2025-04-14', 'lugar': 'Auditorio', 'tipo': 'Académico'},
      {'titulo': 'Torneo de Fútbol', 'descripcion': 'Competencia.', 'fecha': '2025-04-20', 'lugar': 'Canchas', 'tipo': 'Deportivo'},
    ];

    for (var ev in eventos) {
      await db.insert('eventos', ev, conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    // -------- MATERIAS Y CALIFICACIONES SEED DATA --------
    final materias = [
      {
        'clave': 'SCD-1021',
        'nombre': 'Tópicos Avanzados de Programación',
        'creditos': 5,
        'horario': 'Lun|13:00-14:40|T-LC4;Mar|13:00-14:40|T-LC4;Mie|13:00-15:30|T-LC4;Jue|13:00-14:40|T-LC4'
      },
      {
        'clave': 'SCD-1011',
        'nombre': 'Graficación',
        'creditos': 5,
        'horario': 'Lun|09:00-10:40|T-10;Mie|09:00-11:30|T-10;Vie|09:00-10:40|T-10'
      },
      {
        'clave': 'SCD-1015',
        'nombre': 'Lenguajes de Interfaz',
        'creditos': 5,
        'horario': 'Mar|09:00-11:30|T-11;Jue|09:00-11:30|T-11'
      },
      {
        'clave': 'SCA-1020',
        'nombre': 'Redes de Computadoras',
        'creditos': 4,
        'horario': 'Lun|11:00-12:40|T-LR2;Mar|11:00-12:40|T-LR2;Mie|11:00-12:40|T-LR2;Jue|11:00-12:40|T-LR2;Vie|11:00-12:40|T-LR2'
      },
    ];

    for (var m in materias) {
      int mId = await db.insert('materias', {
        'clave': m['clave'],
        'nombre': m['nombre'],
        'creditos': m['creditos'],
        'horario_completo': m['horario']
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      if (mId > 0) {
        // Calificaciones para el alumno 1 (Sebastián)
        await db.insert('calificaciones', {
          'alumno_id': 1,
          'materia_id': mId,
          'u1': 100,
          'u2': 95,
          'u3': 98,
          'u4': null,
          'u5': null,
          'u6': null,
          'periodo': 'Enero - Junio 2026'
        });

        // Calificaciones para el alumno 2 (María)
        await db.insert('calificaciones', {
          'alumno_id': 2,
          'materia_id': mId,
          'u1': 85,
          'u2': 90,
          'u3': 88,
          'u4': null,
          'u5': null,
          'u6': null,
          'periodo': 'Enero - Junio 2026'
        });
      }
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

  // Inscribir alumno a un grupo
  Future<int> inscribirAlumno(int grupoId, int alumnoId) async {
    final db = await _instance.database;
    final id = await db.insert('inscripciones', {
      'usuario_id': alumnoId, 
      'grupo_id': grupoId,
      'fecha_inscripcion': DateTime.now().toIso8601String(),
    });
    print('DEBUG: Inscripción guardada con ID: $id para alumno: $alumnoId');
    return id;
  }

  // Comprobar si ya está inscrito en un taller (haciendo un JOIN)
  Future<bool> estaInscritoEnTaller(int tallerId, int alumnoId) async {
    final db = await _instance.database;
    final result = await db.rawQuery('''
      SELECT i.id FROM inscripciones i
      INNER JOIN grupos g ON i.grupo_id = g.id
      WHERE i.usuario_id = ? AND g.taller_id = ?
    ''', [alumnoId, tallerId]);
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
  Future<List<Map<String, dynamic>>> getComentariosPorAnuncio(int anuncioId) async {
    final db = await instance.database;
    return await db.query('comentarios', where: 'anuncio_id = ?', whereArgs: [anuncioId], orderBy: 'id ASC');
  }

  Future<int> agregarComentario(int anuncioId, String usuario, String texto, int esMaestro) async {
    final db = await instance.database;
    final id = await db.insert('comentarios', {
      'anuncio_id': anuncioId,
      'usuario': usuario,
      'texto': texto,
      'hora': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'es_maestro': esMaestro,
    });
    print('DEBUG: Comentario guardado con ID: $id en anuncio: $anuncioId');
    return id;
  }

  // ── MATERIAS Y CALIFICACIONES ──────────────────────────
  Future<List<Map<String, dynamic>>> getCalificaciones(int alumnoId) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT m.nombre as materia, m.clave, m.creditos, c.u1, c.u2, c.u3, c.u4, c.u5, c.u6, c.periodo
      FROM calificaciones c
      INNER JOIN materias m ON c.materia_id = m.id
      WHERE c.alumno_id = ?
    ''', [alumnoId]);
  }

  Future<List<Map<String, dynamic>>> getCargaAcademica() async {
    final db = await instance.database;
    return await db.query('materias'); // Esto incluye el horario_completo que agregamos
  }

  Future<List<Map<String, dynamic>>> getMaterias() async {
    final db = await instance.database;
    return await db.query('materias');
  }
  Future<List<String>> getAllTables() async {
    final db = await instance.database;
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'android_metadata'");
    return tables.map((t) => t['name'] as String).toList();
  }

  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    final db = await instance.database;
    return await db.query(tableName);
  }
}
