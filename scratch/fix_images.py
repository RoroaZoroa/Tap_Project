import sqlite3

# Configuración
DB_NAME = "itt_portal.db"

def fix_images():
    try:
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        
        # Actualizamos todas las imágenes con URLs reales y bonitas
        updates = [
            ('https://images.unsplash.com/photo-1542038784456-1ea8e935640e?q=80&w=800&auto=format&fit=crop', 'Fotografía'),
            ('https://images.unsplash.com/photo-1574629810360-7efbbe195018?q=80&w=800&auto=format&fit=crop', 'Fútbol'),
            ('https://images.unsplash.com/photo-1555597673-b21d5c935865?q=80&w=800&auto=format&fit=crop', 'Karate'),
            ('https://images.unsplash.com/photo-1547826039-bfc35e0f1ea8?q=80&w=800&auto=format&fit=crop', 'Pintura'),
            ('https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=800&auto=format&fit=crop', 'Ritmos Latinos')
        ]
        
        for url, nombre in updates:
            cursor.execute("UPDATE talleres SET imagen_url = ? WHERE nombre = ?", (url, nombre))
            
        conn.commit()
        conn.close()
        print("Imágenes actualizadas con éxito.")
    except Exception as e:
        print(f"Error al actualizar: {e}")

if __name__ == "__main__":
    fix_images()
