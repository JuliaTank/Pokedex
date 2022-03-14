//
//  PokeService.swift
//  Pokedex
//
//  Created by Julia Tankiewicz on 09/03/2022.
//

import Foundation
import UIKit

//class handles api calls for fetching pokemons data
class PokeService{
    
    let decoder:JSONDecoder!
    let apiBase = "https://pokeapi.co/api/v2/"
    var next:String?
    var pokemons = [Pokemon]()
    var isInPaginationState = false
    var fetchedPokemons = [Pokemon]() //last 20 pokemons
    init(){
        next = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20"
        decoder = JSONDecoder()
    }
    
    //fetches new 20 pokemons
    func fetchPokemons(pagination: Bool, completion: @escaping (Result<Any,Error>)-> Void){
        fetchedPokemons.removeAll()
        if pagination{
            isInPaginationState = true
        }
        if let url = URL(string: next!){
            URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
                guard error == nil, let data = data else{
                    if let error = error {
                        print("Error found while fetching pokemon list \(error.localizedDescription)")
                    }
                    return
                }
                do{
                    let result = try self.decoder.decode(APIResult.self, from: data)
                    self.next = result.next
                    for pokemon in result.results{
                        //fetch each pokemon to get more info about them
                        self.fetchPokemon(url: pokemon.url, completion: completion)
                    }
                    completion(.success(self.fetchedPokemons))
                    if pagination {
                        self.isInPaginationState = false
                    }
                    
                }
                catch let error{
                    print("Error fetching pokemon list: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }).resume()
        }
    }
    
    //fetches info about single pokemon
    func fetchPokemon(url:String, completion: @escaping (Result<Any,Error>)-> Void){
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
                guard error == nil,let data = data else{
                    if let error = error {
                        print("Error found while fetching pokemon \(error.localizedDescription)")
                    }
                    return}
                do{
                    let fetchedPokemon = try self.decoder.decode(APIPokemonResult.self, from: data)
                    //fetch picture-----------------------------------------
                    self.fetchImg(index: self.fetchedPokemons.count ,url: fetchedPokemon.sprites.front_default,completion: completion)
                    //create pokemon object---------------------------------
                    let dic = ["imageUrl": fetchedPokemon.sprites.front_default , "species": fetchedPokemon.species.name ,"name": fetchedPokemon.name, "weight": fetchedPokemon.weight, "height": fetchedPokemon.height,"baseExperience":fetchedPokemon.base_experience,"attack": fetchedPokemon.stats[1].base_stat, "defense":fetchedPokemon.stats[4].base_stat] as [String : Any]
                    let pokemon = Pokemon(id: fetchedPokemon.id, dictionary: dic)
                    //add object to array with all pokemons and return with completion
                    self.pokemons.append(pokemon)
                    self.fetchedPokemons.append(pokemon)
                    completion(.success([pokemon]))
                }
                catch let error{
                    completion(.failure(error))
                    print("Error fetching pokemon: \(error.localizedDescription)")
                }
            }).resume()
        }
    }
   //fetches image for pokemon at index position in fetchedPokemons array
    func fetchImg(index: Int,url:String, completion: @escaping (Result<Any,Error>)-> Void){
    
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url){ data,_,error in
                guard error == nil, let data = data else{return}
                DispatchQueue.main.async {
                    if let img = UIImage(data: data){
                        if index <= self.fetchedPokemons.count{
                            self.fetchedPokemons[index].image = img
                            completion(.success(img))
                        }
                    }else{
                        if index <= self.fetchedPokemons.count{
                        self.fetchedPokemons[index].image = UIImage()
                            completion(.success(UIImage()))
                        }
                    }
                }
                
            }.resume()
        }
    
    }
}

//structs used to decode received API data
struct APIResult:Decodable{
    let next: String
    let results: [APIPokemon]
}
struct APIPokemon:Decodable{
    let name: String
    let url: String
}
struct APIPokemonResult:Decodable{
    let name: String
    let id: Int
    let species: APISpecies
    let sprites: APISprite
    let base_experience: Int
    let height: Int
    let weight: Int
    let stats: [APIStat]
}
struct APISpecies:Decodable{
    let name:String
}
struct APISprite:Decodable{
    let front_default:String
}
struct APIStat:Decodable{
    let base_stat: Int
}
