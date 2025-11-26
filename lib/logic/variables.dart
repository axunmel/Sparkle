// Normal shiny odds from gen 1 to gen 9
const int shinyoddspregen6 = 8192;
const int shinyoddscurrent = 4096;
const int gen2shinygenes = 64;
const int pokeradarodds = 200;
const int gen4masudaodds = 1638;
const int gen5masudaodds = 1365;
const int masudacurrentodds = 683;
const int xyhordes = 4096; 
const int gen6chainfishing = 100;
const int orasdexnav = 512;
const int friendsafari = 819;
const int gen7SOSodds = 683;
const int gen8MaxRaidodds = 4096;
const int gen8DynamaxAdventuresodds = 300;
const int bdspokeradar = 99;
const int gen9sandwich = 1024;

// Shiny odds with shiny charm from gen 5 to gen 9
const int shinycharmoddspregen6 = 2731;
const int shinycharmoddscurrent = 1365;
const int gen5shinycharmasudaodds = 1024;
const int shinycharmasudacurrentodds = 512;
const int gen6shinycharmchainfishings = 96;
const int shinycharmfriendsafari = 585;
const int shiycharmgen7SOSodds = 273;
const int gen8shinycharmdynamaxadventuresodds = 100;
const int gen9shinycharmsandwich = 683;


// All regions from gen 1 to gen 9
const Map<String, String> generationNames = {
  'all': 'All Gens',
  'gen1': 'Gen 1 (Kanto)',
  'gen2': 'Gen 2 (Johto)',
  'gen3': 'Gen 3 (Hoenn)',
  'gen4': 'Gen 4 (Sinnoh)',
  'gen5': 'Gen 5 (Unova)',
  'gen6': 'Gen 6 (Kalos)',
  'gen7': 'Gen 7 (Alola)',
  'gen8': 'Gen 8 (Galar)',
  'gen9': 'Gen 9 (Paldea)',
};

// All games from gen 1 to gen 9
const List<String> pokemonGames = [
  'Pokémon Red', 'Pokémon Blue', 'Pokémon Yellow',
  'Pokémon Gold', 'Pokémon Silver', 'Pokémon Crystal',
  'Pokémon Ruby', 'Pokémon Sapphire', 'Pokémon Emerald',
  'Pokémon FireRed', 'Pokémon LeafGreen', 'Pokemon Colosseum', 'Pokemon XD',
  'Pokémon Diamond', 'Pokémon Pearl', 'Pokémon Platinum',
  'Pokémon HeartGold', 'Pokémon SoulSilver',
  'Pokémon Black', 'Pokémon White', 'Pokémon Black 2', 'Pokémon White 2',
  'Pokémon X', 'Pokémon Y', 'Pokémon Omega Ruby', 'Pokémon Alpha Sapphire',
  'Pokémon Sun', 'Pokémon Moon', 'Pokémon Ultra Sun', 'Pokémon Ultra Moon',
  'Pokémon Let\'s Go, Pikachu!', 'Pokémon Let\'s Go, Eevee!',
  'Pokémon Sword', 'Pokémon Shield', 'Pokémon Brilliant Diamond', 'Pokémon Shining Pearl',
  'Pokémon Scarlet', 'Pokémon Violet', 'Pokemon Legends Z-A',
];


//  
const Map<String, String> gameGenerationMap = {
  'Pokémon Red': 'gen1', 'Pokémon Blue': 'gen1', 'Pokémon Yellow': 'gen1',
  'Pokémon Gold': 'gen2', 'Pokémon Silver': 'gen2', 'Pokémon Crystal': 'gen2',
  'Pokémon Ruby': 'gen3', 'Pokémon Sapphire': 'gen3', 'Pokémon Emerald': 'gen3',
  'Pokémon FireRed': 'gen3', 'Pokémon LeafGreen': 'gen3',
  'Pokemon Colosseum': 'gen3', 'Pokémon XD': 'gen3',
  'Pokémon Diamond': 'gen4', 'Pokémon Pearl': 'gen4', 'Pokémon Platinum': 'gen4',
  'Pokémon HeartGold': 'gen4', 'Pokémon SoulSilver': 'gen4',
  'Pokémon Black': 'gen5', 'Pokémon White': 'gen5', 'Pokémon Black 2': 'gen5', 'Pokémon White 2': 'gen5',
  'Pokémon X': 'gen6', 'Pokémon Y': 'gen6', 'Pokémon Omega Ruby': 'gen6', 'Pokémon Alpha Sapphire': 'gen6',
  'Pokémon Sun': 'gen7', 'Pokémon Moon': 'gen7', 'Pokémon Ultra Sun': 'gen7', 'Pokémon Ultra Moon': 'gen7',
  'Pokémon Let\'s Go, Pikachu!': 'gen7', 'Pokémon Let\'s Go, Eevee!': 'gen7',
  'Pokémon Sword': 'gen8', 'Pokémon Shield': 'gen8', 'Pokémon Brilliant Diamond': 'gen8', 'Pokémon Shining Pearl': 'gen8',
  'Pokémon Scarlet': 'gen9', 'Pokémon Violet': 'gen9', 'Pokemon Legends Z-A': 'gen9',
};


const Map<String, Map<String, bool>> gameFeatures = {
  // Gen 1
  'Pokémon Red': {}, 'Pokémon Blue': {}, 'Pokémon Yellow': {},
  // Gen 2
  'Pokémon Gold': {'hasShinyGenes': true},
  'Pokémon Silver': {'hasShinyGenes': true},
  'Pokémon Crystal': {'hasShinyGenes': true},
  // Gen 3
  'Pokémon Ruby': {}, 'Pokémon Sapphire': {}, 'Pokémon Emerald': {},
  'Pokémon FireRed': {}, 'Pokémon LeafGreen': {}, 
  'Pokémon Colosseum': {}, 'Pokémon XD': {},
  // Gen 4
  'Pokémon Diamond': {'hasRadar': true}, 'Pokémon Pearl': {'hasRadar': true}, 'Pokémon Platinum': {'hasRadar': true},
  'Pokémon HeartGold': {}, 'Pokémon SoulSilver': {},
  // Gen 5
  'Pokémon Black': {}, 'Pokémon White': {},
  'Pokémon Black 2': {'hasCharm': true}, 'Pokémon White 2': {'hasCharm': true},
  // Gen 6
  'Pokémon X': {'hasCharm': true, 'hasRadar': true}, 'Pokémon Y': {'hasCharm': true, 'hasRadar': true},
  'Pokémon Omega Ruby': {'hasCharm': true, 'hasDexNav': true}, 'Pokémon Alpha Sapphire': {'hasCharm': true, 'hasDexNav': true},
  // Gen 7
  'Pokémon Sun': {'hasCharm': true}, 'Pokémon Moon': {'hasCharm': true},
  'Pokémon Let\'s Go, Pikachu!': {'hasCharm': true}, 'Pokémon Let\'s Go, Eevee!': {'hasCharm': true},
  'Pokémon Ultra Sun': {'hasCharm': true, 'hasUltraWormholes': true}, 'Pokémon Ultra Moon': {'hasCharm': true, 'hasUltraWormholes': true},
  // Gen 8
  'Pokémon Sword': {'hasCharm': true}, 'Pokémon Shield': {'hasCharm': true},
  'Pokémon Brilliant Diamond': {'hasCharm': true, 'hasRadar': true, 'needsMasudaCheckbox': true},
  'Pokémon Shining Pearl': {'hasCharm': true, 'hasRadar': true, 'needsMasudaCheckbox': true},
  // Gen 9
  'Pokémon Scarlet': {'hasCharm': true}, 'Pokémon Violet': {'hasCharm': true}, 'Pokemon Legends Z-A': {'hasCharm': true},
};


// All shiny methods for each game from gen 1 to gen 9
const Map<String, List<String>> huntMethods = {
  'Pokémon Red': ['Soft Reset', 'Fishing'],
  'Pokémon Blue': ['Soft Reset', 'Fishing'],
  'Pokémon Yellow': ['Soft Reset', 'Fishing'],
  'Pokémon Gold': ['Wild Encounters', 'Soft Reset', 'Shiny Genes', 'Breeding', 'Fishing'],
  'Pokémon Silver': ['Wild Encounters', 'Soft Reset', 'Shiny Genes', 'Breeding', 'Fishing'],
  'Pokémon Crystal': ['Wild Encounters', 'Soft Reset', 'Shiny Genes', 'Breeding', 'Fishing'],
  'Pokémon Ruby': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing'],
  'Pokémon Sapphire': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing'],
  'Pokémon Emerald': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing'],
  'Pokémon FireRed': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing'],
  'Pokémon LeafGreen': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing'],
  'Pokemon Colosseum': ['Soft Reset'],
  'Pokemon XD': ['Soft Reset'],
  'Pokémon Diamond': ['Wild Encounters', 'Soft Reset', 'Pokè Radar', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon Pearl': ['Wild Encounters', 'Soft Reset', 'Pokè Radar', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon Platinum': ['Wild Encounters', 'Soft Reset', 'Pokè Radar', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon HeartGold': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon SoulSilver': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon Black': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon White': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon Black 2': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon White 2': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method'],
  'Pokémon X': ['Wild Encounters', 'Soft Reset', 'Pokè Radar', 'Breeding', 'Fishing', 'Masuda Method', 'Friend Safari', 'Horde Encounters', 'Chain Fishing'],
  'Pokémon Y': ['Wild Encounters', 'Soft Reset', 'Pokè Radar', 'Breeding', 'Fishing', 'Masuda Method', 'Friend Safari', 'Horde Encounters', 'Chain Fishing'],
  'Pokémon Omega Ruby': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'Chain Fishing', 'DexNav'],
  'Pokémon Alpha Sapphire': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'Chain Fishing', 'DexNav'],
  'Pokémon Sun': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'SOS Battle'],
  'Pokémon Moon': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'SOS Battle'],
  'Pokémon Ultra Sun': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'SOS Battle', 'Ultra Wormholes'],
  'Pokémon Ultra Moon': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'SOS Battle', 'Ultra Wormholes'],
  'Pokémon Sword': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'Dynamax Adventures', 'Max Raid Battle'],
  'Pokémon Shield': ['Wild Encounters', 'Soft Reset', 'Breeding', 'Fishing', 'Masuda Method', 'Dynamax Adventures', 'Max Raid Battle'],
  'Pokémon Brilliant Diamond': ['Wild Encounters', 'Soft Reset', 'Masuda Method', 'Pokè Radar', 'Breeding', 'Fishing'],
  'Pokémon Shining Pearl': ['Wild Encounters', 'Soft Reset', 'Masuda Method', 'Pokè Radar', 'Breeding', 'Fishing'],
  'Pokémon Scarlet': ['Wild Encounters', 'Soft Reset', 'Sandwich', 'Breeding', 'Masuda Method', 'Mass Outbreak'],
  'Pokémon Violet': ['Wild Encounters', 'Soft Reset', 'Sandwich', 'Breeding', 'Masuda Method', 'Mass Outbreak'],
  'Pokemon Legends Z-A': ['Wild Encounters', 'Soft Reset', 'Static Encounters'],
};


// list of all pokemon with shiny lock
const List<String> shinylock = [
  'miraidon', 'koraidon', 'pecharunt', 'terapagos',
  'iron-crown', 'iron-boulder', 'raging-bolt', 'gouging-fire',
  'ogerpon', 'fezandipiti', 'munkidori', 'okidogi', 
  'iron-leaves', 'walking-waves', 'chi-yu', 'ting-lu',
  'chien-pao', 'wo-chien', 'enamorus', 'calyrex',
  'spectrier', 'gastrier', 'kubfu', 'urshifu',
  'zarude', 'marshadow', 'magearna', 'cosmog',
  'cosmoem', 'volcanion', 'hoopa', 'meloetta',
  'keldeo', 'victini', 
];