import 'package:flutter/material.dart';

import 'home_screen.dart'; 
import 'talleres_screen.dart';
import 'perfil_screen.dart';
import '../models/estudiante.dart';

class MainScreen extends StatefulWidget {
  final Estudiante estudiante;
  const MainScreen({super.key, required this.estudiante});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Esta variable guarda el índice de la pantalla actual
  int _selectedIndex = 0;
  
  // Lista de las pantallas que se mostrarán en el body
  late final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(estudiante: widget.estudiante),
    const TalleresScreen(),
    const PerfilScreen(),
  ];

  // Método para actualizar el estado cuando se toca un ícono
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Inicio' : (_selectedIndex == 1 ? 'Talleres' : 'Perfil'),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: 'Talleres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
