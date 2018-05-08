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
  	@pokemons = parsed_response['pokemon']	#gives all the pokemons 
  	
  	@pokemon_id = params[:id]	#gets pokemon name or id from the params hash

  	
  	if @pokemon_id
  		@pokemon = find_pokemon(@pokemon_id, @pokemons)	#passes the info from params and all pokemons to find pokemon method
  		@pokemon_name = @pokemon["name"]	#finds the name of pokemon by looking inside the json response under the key 'name'
  	end
  	giphy_response = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{key}&q=#{@pokemon_name}")
  	giphy_parsed_response = JSON.parse(giphy_response.body)
  	#p giphy_parsed_response.keys
  	giphy_data = giphy_parsed_response["data"]	#this gives all the info on a search query

  	@gif = find_gif(giphy_data)	#gives a single gif when find_gif method is passed the giphy api response

  	respond_to do |format|
  		format.html {render :show}
  		format.json {
  			render json: {pokemon: @pokemon, gif: @gif}	#this is the gateway for sending the api response
  		}
  	end
  end

  private 

  def find_gif(giphy_response)
  	gif_array = []
  	giphy_response.each do |array_index|
  		gif_array.push array_index["images"]["fixed_height"]["url"]
  		return gif_array
  	end
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

