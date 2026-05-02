import 'package:flutter/material.dart';

class CargaTab extends StatelessWidget {
  const CargaTab({super.key});

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
            columnSpacing: 15.0,
            columns: const [
              DataColumn(label: Text('Materia', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Lunes', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Martes', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Miércoles', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Jueves', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Viernes', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('GRAFICACIÓN', style: TextStyle(fontSize: 12))), 
                DataCell(Text('09-10 / T-10')), 
                DataCell(Text('---')), 
                DataCell(Text('09-11 / T-10')),
                DataCell(Text('---')),
                DataCell(Text('09-10 / T-10')),
              ]),
              DataRow(cells: [
                DataCell(Text('LENGUAJES DE INTERFAZ', style: TextStyle(fontSize: 12))), 
                DataCell(Text('---')), 
                DataCell(Text('09-11 / T-11')), 
                DataCell(Text('---')),
                DataCell(Text('09-11 / T-11')),
                DataCell(Text('---')),
              ]),
              DataRow(cells: [
                DataCell(Text('REDES DE COMP.', style: TextStyle(fontSize: 12))), 
                DataCell(Text('11-12 / T-LR2')), 
                DataCell(Text('11-12 / T-LR2')), 
                DataCell(Text('11-12 / T-LR2')),
                DataCell(Text('11-12 / T-LR2')),
                DataCell(Text('11-12 / T-LR2')),
              ]),
              DataRow(cells: [
                DataCell(Text('LENG. Y AUTÓMATAS I', style: TextStyle(fontSize: 12))), 
                DataCell(Text('12-13 / T-16')), 
                DataCell(Text('12-13 / T-16')), 
                DataCell(Text('12-13 / T-16')),
                DataCell(Text('12-13 / T-16')),
                DataCell(Text('12-13 / T-16')),
              ]),
              DataRow(cells: [
                DataCell(Text('TÓPICOS AVAN. PROGR.', style: TextStyle(fontSize: 12))), 
                DataCell(Text('13-14 / T-LC4')), 
                DataCell(Text('13-14 / T-LC4')), 
                DataCell(Text('13-15 / T-LC4')),
                DataCell(Text('13-14 / T-LC4')),
                DataCell(Text('---')),
              ]),
              DataRow(cells: [
                DataCell(Text('INGENIERÍA DE SOFTWARE', style: TextStyle(fontSize: 12))), 
                DataCell(Text('14-16 / T-12')), 
                DataCell(Text('14-15 / T-12')), 
                DataCell(Text('---')),
                DataCell(Text('14-16 / T-12')),
                DataCell(Text('---')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
