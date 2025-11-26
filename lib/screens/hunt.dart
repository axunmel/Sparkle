import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sparkle/logic/shiny_odds_calculator.dart';


class Hunt {
  final String pokemonName;
  final String generationKey;
  final String huntingMethod;
  int count;
  final DateTime startTime;
  DateTime? endTime;
  bool isSuccessful;
  
  String? game; 

  Hunt({
    required this.pokemonName,
    required this.generationKey,
    required this.huntingMethod,
    this.count = 0,
    required this.startTime,
    this.endTime,
    this.isSuccessful = false,
    this.game, 
  });

  void increment() {
    count++;
  }
  
  void decrement() {
    if (count > 0) {
      count--;
    }
  }
}


class HuntScreen extends StatefulWidget {
  final Hunt initialHunt;

  const HuntScreen({
    super.key,
    required this.initialHunt,
  });

  @override
  State<HuntScreen> createState() => _HuntScreenState();
}

class _HuntScreenState extends State<HuntScreen> with SingleTickerProviderStateMixin {
  late Hunt currentHunt;
  late String normalPokemonImagePath;
  late String shinyPokemonImagePath; 

  Duration _elapsedTime = Duration.zero;
  late Ticker _ticker; 
  
  late int huntOddsInverse; 
  double _cumulativeChance = 0.0; 

  @override
  void initState() {
    super.initState();
    currentHunt = widget.initialHunt;
    
    normalPokemonImagePath = 'assets/normal_sprites/${currentHunt.generationKey}/${currentHunt.pokemonName}.png';
    shinyPokemonImagePath = 'assets/shiny_sprites/${currentHunt.generationKey}/${currentHunt.pokemonName}.png'; 
    huntOddsInverse = ShinyOddsCalculator.getOddsValue(
      huntingMethod: currentHunt.huntingMethod,
      generationKey: currentHunt.generationKey,
      game: currentHunt.game, 
      isMasudaBreeding: currentHunt.huntingMethod == 'Masuda Method',
    );
    
    _updateCumulativeChance();
    
    _ticker = createTicker((elapsed) {
      if (mounted && !currentHunt.isSuccessful) {
        setState(() {
          _elapsedTime = elapsed;
        });
      }
    });
    if (!currentHunt.isSuccessful) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
  
  void _updateCumulativeChance() {
    _cumulativeChance = ShinyOddsCalculator.calculateCumulativeProbability(
      inverseOdds: huntOddsInverse, 
      encounters: currentHunt.count,
    );
  }
  
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
  
  void _incrementCount() {
    if (!currentHunt.isSuccessful) {
      setState(() {
        currentHunt.increment();
        _updateCumulativeChance();
      });
    }
  }
  
  void _decrementCount() {
    if (!currentHunt.isSuccessful && currentHunt.count > 0) {
      setState(() {
        currentHunt.decrement();
        _updateCumulativeChance(); 
      });
    }
  }

  void _resetHunt() {
     if (!currentHunt.isSuccessful) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reiniciar Caza'),
          content: const Text(
            '¿Estás seguro de que quieres reiniciar el contador y el temporizador para esta caza?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentHunt.count = 0;
                  _cumulativeChance = 0.0; 
                  _elapsedTime = Duration.zero;
                  _updateCumulativeChance(); 
                  if (!_ticker.isTicking) {
                    _ticker.start();
                  }
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
              child: const Text('Reiniciar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  void _markSuccessful() {
    if (!currentHunt.isSuccessful) {
      setState(() {
        currentHunt.isSuccessful = true;
        currentHunt.endTime = DateTime.now();
        _ticker.stop(); 
      });
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Captura Shiny Exitosa! ✨'),
        content: Text(
          '¡Felicidades! Capturaste a ${currentHunt.pokemonName.toUpperCase()} después de ${currentHunt.count} encuentros en ${_formatDuration(currentHunt.endTime!.difference(currentHunt.startTime))}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Genial'),
          ),
        ],
      ),
    );
  }
  Widget _buildSpriteDisplay(String imagePath, bool isShiny) {
    return Container(
      width: 120, 
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        border: Border.all(color: Colors.grey.shade300, width: 1), 
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => 
              Icon(isShiny ? Icons.star : Icons.catching_pokemon, 
                   size: 50, 
                   color: isShiny ? Colors.amber : Colors.blueGrey),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Color counterColor = Colors.indigo.shade800;
    final statusText = currentHunt.isSuccessful 
        ? 'Caza Completada' 
        : 'Suerte: ${_cumulativeChance.toStringAsFixed(2)}%';
    final oddsText = 'Probabilidad: 1/${huntOddsInverse}'; 
    return Scaffold(
      backgroundColor: Colors.grey.shade100, 
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person_outline, color: Colors.grey),
                        onPressed: () {},
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.grey.shade300,
                      ),
                      IconButton(
                        icon: const Icon(Icons.list_alt, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentHunt.pokemonName.toUpperCase(),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    onPressed: currentHunt.isSuccessful ? null : _resetHunt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), 
            Card(
              elevation: 0, 
              color: Colors.white, 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSpriteDisplay(normalPokemonImagePath, false), 
                    const Icon(Icons.arrow_right_alt, color: Colors.grey, size: 40), 
                    _buildSpriteDisplay(shinyPokemonImagePath, true), 
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_arrow, size: 30, color: Colors.black54),
                  const SizedBox(width: 8),
                  Text(
                    _formatDuration(currentHunt.isSuccessful 
                      ? currentHunt.endTime!.difference(currentHunt.startTime) 
                      : _elapsedTime
                    ),
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                '${currentHunt.count}',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.w900,
                  color: counterColor,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade100, 
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center( 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_half, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Text(
                          statusText,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      oddsText,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              height: 70, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: currentHunt.isSuccessful ? [] : [ 
                  BoxShadow(
                    color: Colors.amber.shade300.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                gradient: currentHunt.isSuccessful 
                    ? LinearGradient(
                        colors: [Colors.green.shade500, Colors.green.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient( 
                        colors: [Colors.amber.shade400, Colors.orange.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.star, color: Colors.white, size: 30), 
                label: Text(
                  currentHunt.isSuccessful ? '¡SHINY CAPTURADO! ✅' : '¡SHINY CAPTURADO!',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), 
                ),
                onPressed: currentHunt.isSuccessful ? null : _markSuccessful,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, 
                  shadowColor: Colors.transparent, 
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0, 
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: currentHunt.isSuccessful ? null : _decrementCount,
                    icon: const Icon(Icons.remove, size: 40, color: Colors.red),
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: currentHunt.isSuccessful ? null : _incrementCount,
                    icon: const Icon(Icons.add, size: 40, color: Colors.deepPurple),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
class NoActiveHuntPlaceholder extends StatelessWidget {
  const NoActiveHuntPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.catching_pokemon,
              size: 100,
              color: Colors.deepPurple.shade300,
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Lets go Hunting!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no has iniciado ninguna caza Shiny. Dirígete a la Pokedex para seleccionar a tu objetivo y comenzar la aventura.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade400),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_downward, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  const Text('Search in pokedex', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}