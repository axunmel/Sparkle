import 'package:flutter/material.dart';
import 'package:sparkle/screens/pokedex.dart';
import 'package:sparkle/screens/hunt.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2;
  Hunt? _activeHunt; 
  void _setActiveHunt(Hunt newHunt) { 
    setState(() {
      _activeHunt = newHunt; 
      _currentIndex = 1; 
    });
  }

  List<Widget> _getScreens() {
    final huntWidget = _activeHunt != null 
        ? HuntScreen(initialHunt: _activeHunt!) 
        : const NoActiveHuntPlaceholder(); 
    
    return [
      const Center(child: Text('WIP: Dashboard', style: TextStyle(fontSize: 24))),
      huntWidget,
      PokedexScreen(onHuntSelected: _setActiveHunt), 
    ];
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Active Hunt';
      case 2:
        return 'Pokédex';
      default:
        return 'Shiny Tracker';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens(); 
    
    int safeIndex = (_currentIndex >= 0 && _currentIndex < screens.length)
        ? _currentIndex
        : 0;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20, 
            color: Colors.black87,
          ),
        ),
        centerTitle: true, 
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(safeIndex),
          child: screens[safeIndex],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, 
        selectedItemColor: Colors.deepPurple,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ads_click),
            label: 'Hunt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.catching_pokemon),
            label: 'Pokedex',
          ),
        ],
      ),
    );
  }
}