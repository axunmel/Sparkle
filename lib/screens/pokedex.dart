import 'package:flutter/material.dart';
import 'package:sparkle/screens/hunt.dart';
import 'package:sparkle/logic/pokemon.dart';
import 'package:sparkle/logic/variables.dart';
import 'package:sparkle/logic/shiny_odds_calculator.dart';

class PokedexScreen extends StatefulWidget {
  final Function(Hunt) onHuntSelected;

  const PokedexScreen({super.key, required this.onHuntSelected});

  @override
  State<PokedexScreen> createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedGenerationKey = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getPokemonNumber(String pokemonName) {
    final index = allPokemonData.indexWhere((p) => p.name == pokemonName);
    return index != -1 ? index + 1 : 0;
  }

  List<PokemonDataSource> _getFilteredPokemon() {
    Iterable<PokemonDataSource> filtered = allPokemonData;
    if (_selectedGenerationKey != 'all') {
      filtered = filtered.where((pokemon) =>
          pokemon.generationFolder == _selectedGenerationKey);
    }
    if (_searchText.isNotEmpty) {
      filtered = filtered.where((pokemon) =>
          pokemon.name.toLowerCase().contains(_searchText.toLowerCase()));
    }
    return filtered.toList();
  }

  String _capitalize(String text) {
    if (text.isEmpty) return '';
    if (text.contains('-') || text.contains('_')) {
      return text.split(RegExp(r'[-_]')).map((word) => _capitalize(word)).join(' ');
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  void _showHuntConfigDialog(BuildContext context, PokemonDataSource pokemon) {
    String capitalizedName = _capitalize(pokemon.name);
    
    if (shinylock.contains(pokemon.name)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            mainAxisSize: MainAxisSize.min, 
            children: const [
              Icon(
                Icons.block, 
                color: Colors.red,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Shiny Lock',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            '$capitalizedName is currently shiny locked and cannot be obtained in Shiny form in recent games. Please select another Pokémon.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okey'),
            ),
          ],
        ),
      );
      return;
    }    
    String? selectedMethod; 
    String? selectedGame;
    bool isMasudaBreeding = false;
    bool hasShinyCharm = false;
    String? _focusedField;
    const Color dialogColor = Colors.white;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(opacity: a1.value, child: child),
        );
      },
      pageBuilder: (context, animation1, animation2) {
        return StatefulBuilder(builder: (context, setState) {
          
          final bool needsMasudaCheckbox = selectedGame != null &&
              (gameFeatures[selectedGame!]?['needsMasudaCheckbox'] ?? false);

          final List<String> availableMethods = selectedGame == null
              ? []
              : (huntMethods[selectedGame!] ?? []);

          if (selectedMethod != null && !availableMethods.contains(selectedMethod)) {
            selectedMethod = null;
          }
          final String? gameGen = gameGenerationMap[selectedGame];
          final bool isGen5OrLater = 
              gameGen == 'gen5' || 
              gameGen == 'gen6' || 
              gameGen == 'gen7' || 
              gameGen == 'gen8' || 
              gameGen == 'gen9';
              
          final bool showShinyCharmCheckbox = 
              selectedGame != null && selectedMethod != null && isGen5OrLater;
              
          if (!showShinyCharmCheckbox) {
             hasShinyCharm = false;
          }
          String getSelectedOddsString() {
            if (selectedMethod == null || selectedGame == null) return '1/8192';
            
            String finalCalculationMethod = selectedMethod!;
            bool isMasuda = isMasudaBreeding && selectedMethod == 'Breeding';

            if (isMasuda) {
                finalCalculationMethod = 'Masuda Method';
            }
            
            String oddsCalculationGenKey = gameGen ?? pokemon.generationFolder;
            
            final String oddsValue = ShinyOddsCalculator.getOddsString(
              huntingMethod: finalCalculationMethod,
              generationKey: oddsCalculationGenKey,
              game: selectedGame, 
              isMasudaBreeding: isMasuda,            );

            final bool isHordeEncounter = finalCalculationMethod == 'Horde Encounter';
            
            return isHordeEncounter ? '5/$oddsValue' : '1/$oddsValue';
          }

          final bool showOptions = selectedGame != null && availableMethods.isNotEmpty;

          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: dialogColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            content: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.5),
                color: dialogColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 10, 10),
                      decoration: BoxDecoration(
                        color: dialogColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/pokemon_icon.png',
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.catching_pokemon,
                                        size: 24, color: Colors.deepPurple),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Hunt $capitalizedName in:',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                _focusedField = hasFocus ? 'game' : null;
                              });
                            },
                            child: DropdownButtonFormField<String>(
                              value: selectedGame,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'Game:',
                                labelStyle: TextStyle(
                                  color: _focusedField == 'game' || selectedGame != null
                                      ? Colors.black54
                                      : Colors.grey.shade600,
                                  fontSize: 15,
                                ),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: _focusedField == 'game'
                                      ? const BorderSide(
                                          color: Colors.deepPurple, width: 2.5)
                                      : BorderSide(
                                          color: Colors.grey.shade400, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple, width: 2.5),
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(12, 22, 12, 10),
                                suffixIcon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: _focusedField == 'game'
                                      ? Colors.deepPurple
                                      : Colors.black54,
                                ),
                              ),
                              hint: const Text(
                                'Select a game',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                              ),
                              items: pokemonGames.map((String game) {
                                return DropdownMenuItem<String>(
                                  value: game,
                                  child: Text(
                                    game,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGame = newValue;
                                  selectedMethod = null; 
                                  isMasudaBreeding = false;
                                  hasShinyCharm = false;
                                  _focusedField = 'game';
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(opacity: animation, child: child),
                              );
                            },
                            child: showOptions
                                ? Focus(
                                    key: const ValueKey<bool>(true),
                                    onFocusChange: (hasFocus) {
                                      setState(() {
                                        _focusedField = hasFocus ? 'method' : null;
                                      });
                                    },
                                    child: DropdownButtonFormField<String>(
                                      value: selectedMethod,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: _focusedField == 'method'
                                              ? const BorderSide(color: Colors.deepPurple, width: 2.5)
                                              : BorderSide(
                                                  color: Colors.grey.shade400, width: 2.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                                        ),
                                        contentPadding: const EdgeInsets.fromLTRB(12, 22, 12, 10),
                                        suffixIcon: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: _focusedField == 'method'
                                              ? Colors.deepPurple
                                              : Colors.black54,
                                        ),
                                      ),
                                      hint: const Text(
                                        'Hunting Method',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                                      ),
                                      items: availableMethods.map((String method) {
                                        String finalCalculationMethod = method;
                                        bool isMasuda = isMasudaBreeding && method == 'Breeding';

                                        if (isMasuda) {
                                            finalCalculationMethod = 'Masuda Method';
                                        }

                                        String oddsCalculationGenKey = gameGen ?? pokemon.generationFolder;

                                        final String oddsValue = ShinyOddsCalculator.getOddsString(
                                          huntingMethod: finalCalculationMethod,
                                          generationKey: oddsCalculationGenKey, 
                                          game: selectedGame, 
                                          isMasudaBreeding: isMasuda,
                                        );

                                        final bool isHordeEncounter = finalCalculationMethod == 'Horde Encounter';
                                        final String oddsPrefix = isHordeEncounter ? '5' : '1';
                                        final String methodOddsString = '$oddsPrefix/$oddsValue';
                                        
                                        return DropdownMenuItem<String>(
                                          value: method,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(method, style: const TextStyle(fontWeight: FontWeight.normal)), 
                                              Text('($methodOddsString)',
                                                  style: TextStyle(
                                                      color: Colors.grey.shade600,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.normal)),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      selectedItemBuilder: (context) {
                                        final String selectedOddsString = getSelectedOddsString();

                                        return availableMethods.map((String method) {
                                          if (method == selectedMethod) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(selectedMethod!, style: const TextStyle(fontWeight: FontWeight.normal)),
                                                Text('($selectedOddsString)',
                                                    style: TextStyle(
                                                        color: Colors.grey.shade600,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.normal)),
                                              ],
                                            );
                                          }
                                          return const SizedBox.shrink();
                                        }).toList();
                                      },
                                      onChanged: (String? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            selectedMethod = newValue;
                                            if (newValue != 'Breeding') {
                                              isMasudaBreeding = false;
                                            }
                                            _focusedField = 'method';
                                          });
                                        }
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink(key: ValueKey<bool>(false)), 
                          ),
                          const SizedBox(height: 15),
                          if (showOptions && needsMasudaCheckbox && selectedMethod == 'Breeding')
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0), 
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 2.0,
                                  ),
                                ),
                                child: CheckboxListTile(
                                  title: const Text('Método Masuda'),
                                  subtitle: const Text('Crianza con Pokémon de idiomas diferentes'),
                                  value: isMasudaBreeding,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isMasudaBreeding = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.deepPurple.shade300,
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              ),
                            ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(opacity: animation, child: child),
                              );
                            },
                            child: showShinyCharmCheckbox
                                ? Padding(
                                    key: const ValueKey<bool>(true),
                                    padding: const EdgeInsets.only(top: 15.0), 
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: CheckboxListTile(
                                        title: const Text('Shiny Charm'),
                                        subtitle: Text('¿Tienes el Shiny Charm en ${selectedGame!}?'),
                                        value: hasShinyCharm,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            hasShinyCharm = value ?? false;
                                          });
                                        },
                                        activeColor: Colors.deepPurple.shade300,
                                        controlAffinity: ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(key: ValueKey<bool>(false)), 
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: selectedGame == null || availableMethods.isEmpty || selectedMethod == null
                          ? null
                          : () {
                              final String finalHuntingMethod =
                                  (needsMasudaCheckbox &&
                                          selectedMethod == 'Breeding' &&
                                          isMasudaBreeding)
                                      ? 'Masuda Method'
                                      : selectedMethod!;

                              final newHunt = Hunt(
                                pokemonName: pokemon.name,
                                generationKey: pokemon.generationFolder,
                                huntingMethod: finalHuntingMethod,
                                game: selectedGame, 
                                count: 0,
                                startTime: DateTime.now(),
                              );

                              widget.onHuntSelected(newHunt);
                              Navigator.of(context).pop();
                            },
                      child: const Text('Start'),
                    ),
                  ],
                ),
              )
            ],
          );
        });
      },
    );
  }

  Widget _buildPokemonCard(BuildContext context, PokemonDataSource pokemon) {
    final capitalizedName = _capitalize(pokemon.name);
    final pokemonNumber = _getPokemonNumber(pokemon.name);
    final numberString = '#${pokemonNumber.toString().padLeft(3, '0')}';
    final imagePath =
        'assets/normal_sprites/${pokemon.generationFolder}/${pokemon.name}.png';

    return GestureDetector(
      onTap: () => _showHuntConfigDialog(context, pokemon),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: Colors.white, 
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.catching_pokemon, color: Colors.deepPurple.shade300, size: 50),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400, width: 1),
                        ),
                        child: Text(
                          numberString,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4), 
                ),
                child: Text(
                  capitalizedName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredPokemon();

    return Container( 
      color: Colors.white, 
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 10.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Pokémon...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedGenerationKey,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                      dropdownColor: Colors.white,
                      items: generationNames.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(
                            entry.value,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGenerationKey = newValue ?? 'all';
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        _searchText.isNotEmpty
                            ? 'No Pokémon found matching "$_searchText"'
                            : 'No Pokémon found in this generation.',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, 
                      childAspectRatio: 0.75, 
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final pokemon = filtered[index];
                      return _buildPokemonCard(context, pokemon);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}