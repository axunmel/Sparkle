// logic/shiny_odds_calculator.dart

import 'package:sparkle/logic/variables.dart'; 
import 'dart:math';

class ShinyOddsCalculator {
  
  /// Calcula el denominador (el valor X en la relación 1/X) de la probabilidad Shiny.
  static int getOddsValue({
    required String huntingMethod,
    required String generationKey,
    required String? game,
    bool isMasudaBreeding = false,
    bool hasShinyCharm = false,
  }) {

    final bool isMasudaHunt = huntingMethod == 'Masuda Method' || 
                              (huntingMethod == 'Breeding' && isMasudaBreeding);
                              
    // 1. Lógica del MÉTODO MASUDA con Shiny Charm
    if (isMasudaHunt) {
        switch (generationKey) {
            case 'gen4':
                // Masuda Gen 4: 1/1638 (No hay Charm en Gen 4)
                return gen4masudaodds; 
            case 'gen5':
                // Masuda Gen 5: 1/1365, 1/1024 con Charm
                return hasShinyCharm ? gen5shinycharmasudaodds : gen5masudaodds; 
            case 'gen6':
            case 'gen7':
            case 'gen8':
            case 'gen9':
                // Masuda Gen 6+: 1/683, 1/512 con Charm
                return hasShinyCharm ? shinycharmasudacurrentodds : masudacurrentodds;
            default:
                break;
        }
    }
    
    // 2. Lógica de MÉTODOS ESPECIALES
    switch (generationKey) {
      case 'gen2':
        if (huntingMethod == 'Shiny Genes') {
          return gen2shinygenes; 
        }
        break;
        
      case 'gen4':
        if (huntingMethod == 'Pokè Radar') {
          return pokeradarodds; // Asumimos la odds de cadena máxima ~1/200
        }
        break;
        
      case 'gen6':
        // **Lógica de Gen 6 (XY/ORAS)**
        if (huntingMethod == 'Pokè Radar') {
          return pokeradarodds; 
        }
        if (huntingMethod == 'Horde Encounters'){
           // El denominador es 4096 (la odds es 5/4096)
           return hasShinyCharm ? shinycharmoddscurrent : shinyoddscurrent;
        }
        if (huntingMethod == 'Friend Safari') {
          // 1/819 o 1/585 con Charm
          return hasShinyCharm ? shinycharmfriendsafari : friendsafari; 
        }
        if (huntingMethod == 'Chain Fishing'){
          // 1/100 o 1/96 con Charm (gen6shinycharmchainfishings)
           return hasShinyCharm ? gen6shinycharmchainfishings : gen6chainfishing; 
        }
        if (huntingMethod == 'DexNav'){
           // 1/512
           return hasShinyCharm ? orasdexnavshinycharm : orasdexnav;
        }
        break; 
        
      case 'gen7':
        if (huntingMethod == 'SOS Battle') {
           return hasShinyCharm ? shiycharmgen7SOSodds : gen7SOSodds;
        }
        if (huntingMethod == 'Ultra Wormholes'){
           return hasShinyCharm ? shinycharmoddscurrent : shinyoddscurrent;
        }
        break; 

      case 'gen8':
        if (huntingMethod == 'Dynamax Adventures') {
          return hasShinyCharm ? gen8shinycharmdynamaxadventuresodds : gen8DynamaxAdventuresodds; 
        }
        if (huntingMethod == 'Pokè Radar'){
          return bdspokeradar;
        }        break; 

      case 'gen9':
        if (huntingMethod == 'Sandwich'){
           return hasShinyCharm ? gen9shinycharmsandwich : gen9sandwich;
        }
        break; 
        
      default:
        break;
    }
    switch (generationKey) {
        case 'gen5':
             // Gen 5 Base: 1/8192 o 1/2731 con Charm
            return hasShinyCharm ? shinycharmoddspregen6 : shinyoddspregen6;
            
        case 'gen6':
        case 'gen7':
        case 'gen8':
        case 'gen9':
            // Base Odds Gen 6+: 1/4096 o 1/1365 con Charm
            return hasShinyCharm ? shinycharmoddscurrent : shinyoddscurrent;
        
        default:
            // Generaciones por defecto (Gen 1-4 Base: 1/8192)
            return shinyoddspregen6; 
    }
  }

  /// Devuelve la cadena X o la cadena completa (ej: 5/X) para ser mostrada en el UI.
  static String getOddsString({
    required String huntingMethod,
    required String generationKey,
    required String? game,
    bool isMasudaBreeding = false,
    bool hasShinyCharm = false,
  }) {
    final int odds = getOddsValue(
      huntingMethod: huntingMethod,
      generationKey: generationKey,
      game: game,
      isMasudaBreeding: isMasudaBreeding,
      hasShinyCharm: hasShinyCharm,
    );
    
    // Caso especial: Hordas (la probabilidad real es 5/4096)
    if (huntingMethod == 'Horde Encounters' && generationKey == 'gen6') {
        return '5/$odds';
    }
    
    // Para todos los demás, devolvemos solo el denominador (X)
    return odds.toString();
  }
  
  /// Calcula la probabilidad acumulativa de haber encontrado un Shiny después de N encuentros.
  static double calculateCumulativeProbability({
    required int inverseOdds, 
    required int encounters,
  }) {
    if (inverseOdds <= 0 || encounters <= 0) return 0.0;
    
    final double X = inverseOdds.toDouble();
    final double N = encounters.toDouble();
    
    // Probabilidad de fallar en un intento: (X - 1) / X
    final double probabilityOfFailure = (X - 1) / X;
    
    // Probabilidad de no tener éxito después de N intentos: ((X - 1) / X)^N
    // Probabilidad acumulativa: 1 - P(no éxito)
    final double cumulativeDecimal = 1.0 - pow(probabilityOfFailure, N); 
    
    return cumulativeDecimal * 100.0;
  }
}