import sqlite3
import os

# Configuración
DB_NAME = "itt_portal.db"

def create_full_db():
    if os.path.exists(DB_NAME):
        try:
            os.remove(DB_NAME)
        except:
            print("No se pudo borrar el archivo (está abierto). Intentaré actualizarlo.")
    
    conn = sqlite3.connect(DB_NAME)
    cursor = conn.cursor()

    # --- ESQUEMA COMPLETO ---
    cursor.executescript('''
    CREATE TABLE IF NOT EXISTS alumnos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        num_control TEXT UNIQUE NOT NULL,
        nombre TEXT NOT NULL,
        carrera TEXT NOT NULL,
        semestre TEXT NOT NULL,
        email TEXT NOT NULL,
        password TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS materias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clave TEXT UNIQUE NOT NULL,
        nombre TEXT NOT NULL,
        creditos INTEGER NOT NULL,
        horario_completo TEXT -- Para la tabla de carga (ej: Lun 9-11, Vie 9-10)
    );

    CREATE TABLE IF NOT EXISTS calificaciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alumno_id INTEGER NOT NULL,
        materia_id INTEGER NOT NULL,
        u1 INTEGER, u2 INTEGER, u3 INTEGER, u4 INTEGER, u5 INTEGER, u6 INTEGER,
        periodo TEXT NOT NULL,
        FOREIGN KEY (alumno_id) REFERENCES alumnos (id),
        FOREIGN KEY (materia_id) REFERENCES materias (id)
    );

    CREATE TABLE IF NOT EXISTS talleres (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        categoria TEXT NOT NULL,
        es_representativo INTEGER NOT NULL,
        maestro_nombre TEXT NOT NULL,
        imagen_url TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS grupos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taller_id INTEGER NOT NULL,
        nombre_grupo TEXT NOT NULL,
        horario TEXT NOT NULL,
        FOREIGN KEY (taller_id) REFERENCES talleres (id)
    );

    CREATE TABLE IF NOT EXISTS inscripciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        grupo_id INTEGER NOT NULL,
        fecha_inscripcion TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES alumnos (id),
        FOREIGN KEY (grupo_id) REFERENCES grupos (id)
    );

    CREATE TABLE IF NOT EXISTS anuncios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taller_id INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        contenido TEXT NOT NULL,
        fecha TEXT NOT NULL,
        FOREIGN KEY (taller_id) REFERENCES talleres (id)
    );

    CREATE TABLE IF NOT EXISTS eventos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        fecha TEXT NOT NULL,
        lugar TEXT NOT NULL,
        tipo TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS comentarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anuncio_id INTEGER NOT NULL,
        usuario TEXT NOT NULL,
        texto TEXT NOT NULL,
        hora TEXT NOT NULL,
        es_maestro INTEGER NOT NULL,
        FOREIGN KEY (anuncio_id) REFERENCES anuncios (id)
    );
    ''')

    # --- DATOS DE PRUEBA (SEED DATA) ---
    
    # Usuario Demo
    cursor.execute("INSERT OR IGNORE INTO alumnos (num_control, nombre, carrera, semestre, email, password) VALUES (?, ?, ?, ?, ?, ?)", 
                  ('23281337', 'Sebastián Ballesteros Gutierrez', 'Ingeniería en Sistemas Computacionales', '4to Semestre', '23281337@toluca.tecnm.mx', 'PW104'))
    alumno_id = 1

    # Materias con Horarios (Para CargaTab)
    # Formato Horario: Dia|Hora|Salon (separados por ;)
    materias = [
        ('SCD-1008', 'TÓPICOS AVAN. DE PROGR.', 5, 'Lun|13-14|T-LC4;Mar|13-14|T-LC4;Mie|13-15|T-LC4;Jue|13-14|T-LC4'),
        ('SCA-1014', 'GRAFICACIÓN', 4, 'Lun|09-10|T-10;Mie|09-11|T-10;Vie|09-10|T-10'),
        ('SCC-1005', 'LENG. Y AUTÓMATAS I', 5, 'Lun|12-13|T-16;Mar|12-13|T-16;Mie|12-13|T-16;Jue|12-13|T-16;Vie|12-13|T-16'),
        ('SCC-1017', 'REDES DE COMPUTADORAS', 4, 'Lun|11-12|T-LR2;Mar|11-12|T-LR2;Mie|11-12|T-LR2;Jue|11-12|T-LR2;Vie|11-12|T-LR2'),
        ('SCC-1013', 'INGENIERÍA DE SOFTWARE', 4, 'Lun|14-16|T-12;Mar|14-15|T-12;Jue|14-16|T-12')
    ]
    for clave, nombre, cred, horario in materias:
        cursor.execute("INSERT OR IGNORE INTO materias (clave, nombre, creditos, horario_completo) VALUES (?, ?, ?, ?)", (clave, nombre, cred, horario))
        cursor.execute("SELECT id FROM materias WHERE clave = ?", (clave,))
        m_id = cursor.fetchone()[0]
        
        # Calificaciones (Para CalificacionesTab)
        cursor.execute("INSERT OR IGNORE INTO calificaciones (alumno_id, materia_id, u1, u2, u3, u4, u5, u6, periodo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", 
                      (alumno_id, m_id, 95, 98, 100, None, None, None, 'Ene-Jun 2025'))

    # Talleres con IMÁGENES REALES
    talleres_list = [
        ('Fotografía', 'Artístico', 'Prof. Luis Mendoza', 'https://images.unsplash.com/photo-1542038784456-1ea8e935640e?q=80&w=800&auto=format&fit=crop'),
        ('Fútbol', 'Deportivo', 'Coach Martín Torres', 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=800&auto=format&fit=crop'),
        ('Karate', 'Deportivo', 'Sensei Juan Pérez', 'https://images.unsplash.com/photo-1555597673-b21d5c935865?q=80&w=800&auto=format&fit=crop')
    ]
    for nombre, cat, maestro, img in talleres_list:
        cursor.execute("INSERT OR IGNORE INTO talleres (nombre, descripcion, categoria, es_representativo, maestro_nombre, imagen_url) VALUES (?, ?, ?, 0, ?, ?)", 
                      (nombre, f'Desarrolla tu potencial en el taller de {nombre}.', cat, maestro, img))
        cursor.execute("SELECT id FROM talleres WHERE nombre = ?", (nombre,))
        t_id = cursor.fetchone()[0]
        
        cursor.execute("INSERT OR IGNORE INTO grupos (taller_id, nombre_grupo, horario) VALUES (?, 'Grupo A', 'Lun y Mié 14:00-16:00')", (t_id,))
        cursor.execute("INSERT OR IGNORE INTO anuncios (taller_id, titulo, contenido, fecha) VALUES (?, '¡Bienvenidos!', 'Hola a todos, iniciamos curso.', '2025-03-05')", (t_id,))

    conn.commit()
    conn.close()
    print(f"Base de datos '{DB_NAME}' actualizada con horarios y calificaciones.")

if __name__ == "__main__":
    create_full_db()
