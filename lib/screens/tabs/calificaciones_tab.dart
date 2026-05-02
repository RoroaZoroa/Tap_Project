import 'package:flutter/material.dart';

class CalificacionesTab extends StatelessWidget {
  const CalificacionesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
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
            rows: const [
              DataRow(cells: [
                DataCell(Text('TÓPICOS AVAN. DE PROGR.', style: TextStyle(fontSize: 12))),
                DataCell(Text('100')), DataCell(Text('95')), DataCell(Text('98')), 
                DataCell(Text('---')), DataCell(Text('---')), DataCell(Text('---')),
              ]),
              DataRow(cells: [
                DataCell(Text('GRAFICACIÓN', style: TextStyle(fontSize: 12))),
                DataCell(Text('85')), DataCell(Text('90')), DataCell(Text('88')), 
                DataCell(Text('---')), DataCell(Text('---')), DataCell(Text('---')),
              ]),
              DataRow(cells: [
                DataCell(Text('LENG. Y AUTÓMATAS I', style: TextStyle(fontSize: 12))),
                DataCell(Text('90')), DataCell(Text('92')), DataCell(Text('---')), 
                DataCell(Text('---')), DataCell(Text('---')), DataCell(Text('---')),
              ]),
              DataRow(cells: [
                DataCell(Text('REDES DE COMPUTADORAS', style: TextStyle(fontSize: 12))),
                DataCell(Text('76')), DataCell(Text('80')), DataCell(Text('---')), 
                DataCell(Text('---')), DataCell(Text('---')), DataCell(Text('---')),
              ]),
              DataRow(cells: [
                DataCell(Text('INGENIERÍA DE SOFTWARE', style: TextStyle(fontSize: 12))),
                DataCell(Text('84')), DataCell(Text('88')), DataCell(Text('85')), 
                DataCell(Text('---')), DataCell(Text('---')), DataCell(Text('---')),
              ]),
              DataRow(cells: [
                DataCell(Text('LENGUAJES DE INTERFAZ', style: TextStyle(fontSize: 12))),
                DataCell(Text('80')), DataCell(Text('82')), DataCell(Text('---')), 
                DataCell(Text('---')), DataCell(Text('---')), DataCell(Text('---')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
