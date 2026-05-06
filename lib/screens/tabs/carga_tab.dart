import 'package:flutter/material.dart';
import '../../data/database_helper.dart';

class CargaTab extends StatefulWidget {
  const CargaTab({super.key});

  @override
  State<CargaTab> createState() => _CargaTabState();
}

class _CargaTabState extends State<CargaTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getHorarioParaDia(String? horarioCompleto, String diaBusqueda) {
    if (horarioCompleto == null || horarioCompleto.isEmpty) return '---';
    final partes = horarioCompleto.split(';');
    for (var parte in partes) {
      final info = parte.split('|');
      if (info.length >= 2 && info[0].trim().toLowerCase().startsWith(diaBusqueda.toLowerCase().substring(0, 3))) {
        return info.length == 3 ? '${info[1]} / ${info[2]}' : info[1];
      }
    }
    return '---';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getCargaAcademica(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final materias = snapshot.data!;

        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                ),
                columnSpacing: 15.0,
                columns: const [
                  DataColumn(label: Text('Materia', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Lunes', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Martes', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Miércoles', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Jueves', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Viernes', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: materias.map((m) {
                  final h = m['horario_completo'] as String?;
                  return DataRow(cells: [
                    DataCell(Text(m['nombre'], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500))),
                    DataCell(Text(_getHorarioParaDia(h, 'Lun'), style: const TextStyle(fontSize: 10))),
                    DataCell(Text(_getHorarioParaDia(h, 'Mar'), style: const TextStyle(fontSize: 10))),
                    DataCell(Text(_getHorarioParaDia(h, 'Mie'), style: const TextStyle(fontSize: 10))),
                    DataCell(Text(_getHorarioParaDia(h, 'Jue'), style: const TextStyle(fontSize: 10))),
                    DataCell(Text(_getHorarioParaDia(h, 'Vie'), style: const TextStyle(fontSize: 10))),
                  ]);
                }).toList(),
              ),
            ),
          ),
        );
      }
    );
  }
}
