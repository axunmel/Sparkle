import 'package:sparkle/logic/variables.dart'; 
import 'dart:math';

class ShinyOddsCalculator {
  
  static int getOddsValue({
    required String huntingMethod,
    required String generationKey,
    required String? game,
    bool isMasudaBreeding = false,
  }) {

    final bool isMasudaHunt = huntingMethod == 'Masuda Method' || 
                              (huntingMethod == 'Breeding' && isMasudaBreeding);
                              
    if (isMasudaHunt) {
        switch (generationKey) {
            case 'gen4':
                return gen4masudaodds; 
            case 'gen5':
                return gen5masudaodds; 
            case 'gen6':
                return masudacurrentodds; 
             case 'gen7':
                return masudacurrentodds;
             case 'gen8':
                return masudacurrentodds; 
             case 'gen9':
                return masudacurrentodds;
            default:
                break;
        }
    }
    switch (generationKey) {
      case 'gen2':
        if (huntingMethod == 'Shiny Genes') {
          return gen2shinygenes; 
        }
        break;
        
      case 'gen4':
        if (huntingMethod == 'Pokè Radar') {
          return pokeradarodds;
        }
        break;
        
      case 'gen6':
        if (huntingMethod == 'Friend Safari') {
          return friendsafari; 
        }
        if (huntingMethod == 'Chain Fishing'){
           return gen6chainfishing; 
        }
        if (huntingMethod == 'DexNav'){
           return orasdexnav; 
        }
        break; 
        
      case 'gen7':
        if (huntingMethod == 'SOS Battle') {
          return gen7SOSodds; 
        }
        break; 
        
      case 'gen8':
        if (huntingMethod == 'Dynamax Adventures') {
          return gen8DynamaxAdventuresodds; 
        }
        if (huntingMethod == 'Pokè Radar'){
          return bdspokeradar;
        }
        break; 

      case 'gen9':
        if (huntingMethod == 'Sandwich'){
          return gen9sandwich;
        }
        break; 
        
      default:
        break;
    }
    switch (generationKey) {
        case 'gen6':
        case 'gen7':
        case 'gen8':
        case 'gen9':
            return shinyoddscurrent;
        
        default:
            return shinyoddspregen6; 
    }
  }

  static String getOddsString({
    required String huntingMethod,
    required String generationKey,
    required String? game,
    bool isMasudaBreeding = false,
  }) {
    final int odds = getOddsValue(
      huntingMethod: huntingMethod,
      generationKey: generationKey,
      game: game,
      isMasudaBreeding: isMasudaBreeding,
    );
    return odds.toString();
  }
  
  static double calculateCumulativeProbability({
    required int inverseOdds, 
    required int encounters,
  }) {
    if (inverseOdds <= 0 || encounters <= 0) return 0.0;
    
    final double X = inverseOdds.toDouble();
    final double N = encounters.toDouble();
    
    final double probabilityOfFailure = (X - 1) / X;
    
    final double cumulativeDecimal = 1.0 - pow(probabilityOfFailure, N);
    
    return cumulativeDecimal * 100.0;
  }
}