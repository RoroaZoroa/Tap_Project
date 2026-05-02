import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import 'taller_detalle_screen.dart'; // Importante para que el botón "Entrar" funcione

class TalleresScreen extends StatefulWidget {
  const TalleresScreen({super.key});

  @override
  State<TalleresScreen> createState() => _TalleresScreenState();
}

class _TalleresScreenState extends State<TalleresScreen> {
  String _filtroActual = 'Todos';
  List<int> _talleresInscritos = [];

  @override
  void initState() {
    super.initState();
    _cargarInscripciones();
  }

  Future<void> _cargarInscripciones() async {
    final talleres = await DatabaseHelper().getTalleres();
    List<int> inscritosTemp = [];
    for (var taller in talleres) {
      bool inscrito = await DatabaseHelper().estaInscritoEnTaller(taller['id']);
      if (inscrito) {
        inscritosTemp.add(taller['id']);
      }
    }
    if (!mounted) return;
    setState(() {
      _talleresInscritos = inscritosTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Talleres Extracurriculares'),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getTalleres(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay talleres disponibles.'));
          }

          final todosLosTalleres = snapshot.data!;
          final misTalleres = todosLosTalleres.where((t) => _talleresInscritos.contains(t['id'])).toList();
          final talleresDisponibles = todosLosTalleres.where((t) {
            bool noInscrito = !_talleresInscritos.contains(t['id']);
            bool pasaFiltro = _filtroActual == 'Todos' || t['categoria'] == _filtroActual;
            return noInscrito && pasaFiltro;
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (misTalleres.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Mis Talleres',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: misTalleres.length,
                    itemBuilder: (context, index) => _buildTallerCard(misTalleres[index], yaInscrito: true),
                  ),
                  const Divider(height: 32, thickness: 1, indent: 16, endIndent: 16),
                ],

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    'Explorar Talleres',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                ),
                _buildFiltros(),
                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: talleresDisponibles.length,
                  itemBuilder: (context, index) => _buildTallerCard(talleresDisponibles[index], yaInscrito: false),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltros() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ['Todos', 'Deportivo', 'Artístico'].map((categoria) {
          return ChoiceChip(
            label: Text(categoria),
            selected: _filtroActual == categoria,
            onSelected: (selected) {
              setState(() {
                _filtroActual = categoria;
              });
            },
            selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTallerCard(Map<String, dynamic> taller, {required bool yaInscrito}) {
    final theme = Theme.of(context);
    final int tallerId = taller['id'];
    final bool esRepresentativo = taller['es_representativo'] == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(taller['imagen_url'], height: 140, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(taller['nombre'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: taller['categoria'] == 'Deportivo' ? Colors.orange.withValues(alpha: 0.2) : Colors.purple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        taller['categoria'],
                        style: TextStyle(
                          fontSize: 12,
                          color: taller['categoria'] == 'Deportivo' ? Colors.orange[700] : Colors.purple[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(taller['descripcion'], style: TextStyle(color: theme.hintColor, fontSize: 14)),
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (yaInscrito) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TallerDetalleScreen(taller: taller)),
                        );
                      } else if (!esRepresentativo) {
                        _mostrarOpcionesHorario(tallerId, taller['nombre']);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yaInscrito ? Colors.green : (esRepresentativo ? theme.disabledColor : theme.colorScheme.primary),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      yaInscrito ? 'Entrar al Taller' : (esRepresentativo ? 'Solo por invitación' : 'Elegir Horario e Inscribirse'),
                      style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarOpcionesHorario(int tallerId, String nombreTaller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper().getGruposPorTaller(tallerId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
            
            final grupos = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Elige tu horario para $nombreTaller', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ...grupos.map((grupo) {
                    return ListTile(
                      leading: const Icon(Icons.schedule, color: Color(0xFF3F51B5)),
                      title: Text(grupo['nombre_grupo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(grupo['horario']),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        await DatabaseHelper().inscribirAlumno(grupo['id']);
                        if (context.mounted) Navigator.pop(context);
                        _cargarInscripciones();
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
