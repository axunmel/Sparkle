#!/bin/zsh


# This script downloads all sprites for all Pokémon from Gen 1 to Gen 9
# Total Pokémon: 1025 (as of 10/27/2025)
mkdir -p normal_sprite/gen{1..9}
mkdir -p shiny_sprite/gen{1..9}

# this loop download all Pokemon HOME Sprite form gen 1 to gen 9
for i in $(seq 1 1025); do
    # Nombre del Pokémon
    pokemon=$(curl -s "https://pokeapi.co/api/v2/pokemon/$i" | jq -r '.forms[0].name')

    #this block of code save the generation of each pokemon 
    generation=$(curl -s "https://pokeapi.co/api/v2/pokemon-species/$i" | jq -r '.generation.url')
    generation="${generation%/}"        
    gen_number="${generation: -1}"     

    echo "Downloading $pokemon.png (Gen $gen_number)"

    #Download the normal sprite
    wget -q -O "$pokemon.png" "https://img.pokemondb.net/sprites/home/normal/$pokemon.png"
    mv "$pokemon.png" "normal_sprite/gen$gen_number/"

    #Download the shiny sprite
    wget -q -O "$pokemon.png" "https://img.pokemondb.net/sprites/home/shiny/$pokemon.png"
    mv "$pokemon.png" "shiny_sprite/gen$gen_number/"
done
