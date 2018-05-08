class PokemonsController < ApplicationController
  def index
  	response = HTTParty.get('https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json')
  	parsed_response = JSON.parse(response.body)
  	@pokemons = parsed_response['pokemon']
  end

  def show
  	response = HTTParty.get('https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json')
  	parsed_response = JSON.parse(response.body)

  	key = ENV['GIPHY_KEY']
  	
  	#p parsed_response.keys
  	@pokemons = parsed_response['pokemon']
  	
  	@pokemon_id = params[:id]

  	
  	if @pokemon_id
  		@pokemon = find_pokemon(@pokemon_id, @pokemons)
  		@pokemon_name = @pokemon["name"]
  	end
  	giphy_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{key}&q=#{@pokemon_name}")
  	giphy_parsed_response = JSON.parse(giphy_response.body)
  	#p giphy_parsed_response.keys
  	p giphy_parsed_response["data"]
  	respond_to do |format|
  		format.html {render :show}
  		format.json {
  			render json: {pokemons: @pokemons}
  		}
  	end
  end

  private 

  def find_gif(giphy_response)
  	

  end
  def find_pokemon(attribute, pokemons)

	  	if attribute.to_i != 0 
	  		pokemons.each do |pokemon|
	  			if pokemon["id"] == attribute.to_i
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

