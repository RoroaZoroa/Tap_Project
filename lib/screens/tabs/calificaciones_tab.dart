import 'package:flutter/material.dart';
import '../../data/database_helper.dart';

class CalificacionesTab extends StatefulWidget {
  final int alumnoId;
  const CalificacionesTab({super.key, required this.alumnoId});

  @override
  State<CalificacionesTab> createState() => _CalificacionesTabState();
}

class _CalificacionesTabState extends State<CalificacionesTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getCalificaciones(widget.alumnoId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final calificaciones = snapshot.data!;
        
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
                columnSpacing: 18.0,
                columns: const [
                  DataColumn(label: Text('Materia', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('U1', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('U2', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('U3', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('U4', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('U5', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('U6', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: calificaciones.map((item) {
                  return DataRow(cells: [
                    DataCell(Text(item['materia'], style: const TextStyle(fontSize: 11))),
                    DataCell(Text(item['u1']?.toString() ?? '---')),
                    DataCell(Text(item['u2']?.toString() ?? '---')),
                    DataCell(Text(item['u3']?.toString() ?? '---')),
                    DataCell(Text(item['u4']?.toString() ?? '---')),
                    DataCell(Text(item['u5']?.toString() ?? '---')),
                    DataCell(Text(item['u6']?.toString() ?? '---')),
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
