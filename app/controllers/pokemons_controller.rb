class PokemonsController < ApplicationController
  def index
  	
  end

  def show
  	response = HTTParty.get('https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json')
  	parsed_response = JSON.parse(response.body)
  	#p parsed_response.keys
  	@pokemons = parsed_response['pokemon']
  	
  	@pokemon_id = params[:id]

  	if @pokemon_id
  		@pokemon = find_pokemon(@pokemon_id, @pokemons)
  	end
  end
  private 

  def find_pokemon(attribute, pokemons)

	  	if attribute.to_i != 0 
	  		pokemons.each do |pokemon|
	  			if pokemon["id"] == attribute.to_i
	  				p pokemon['id']
	  				return pokemon
	  			end 
	  		end
	  	elsif attribute.to_i == 0
	  		pokemons.each do |pokemon|
	  			if pokemon["name"] == attribute.capitalize
	  				return pokemon
	  			end
	  		end
	  	end
  end
  


end

