//
//  PokeService.swift
//  Pokedex
//
//  Created by Julia Tankiewicz on 09/03/2022.
//

import Foundation
import UIKit

class PokeService{
    
    let decoder:JSONDecoder!
    let apiBase = "https://pokeapi.co/api/v2/"
    var next:String?
    var pokemons = [Pokemon]()
    var isInPaginationState = false
    
    init(){
        next = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=20"
        decoder = JSONDecoder()
    }
    
    func fetchPokemons(pagination: Bool, completion: @escaping (Result<[Pokemon],Error>)-> Void){
        if pagination{
            isInPaginationState = true
        }
        if let url = URL(string: next!){
            URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
                guard error == nil, let data = data else{return}
                do{
                    //list with new 20 pokemons that will be returned with completion
                    var fetchedPokemons = [Pokemon]()
                    let result = try self.decoder.decode(APIResult.self, from: data)
                    self.next = result.next
                    for pokemon in result.results{
                        let dic = ["name": pokemon.name] as [String : Any]
                        let pokemonf = Pokemon(id:1, dictionary: dic)
                        fetchedPokemons.append(pokemonf)
                    }
                    completion(.success(fetchedPokemons))
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
    
    
    //fetch pokemon
//    var fetchedPokemon:Pokemon?
//    self.fetchPokemon(url: pokemon.url){ pokemonResult in
//       fetchedPokemon = pokemonResult
//    }
//    if fetchedPokemon != nil{
//        fetchedPokemons.append(fetchedPokemon!)
//    }
    
    //TODO: Probably needs to be called separately not one inside another?
    
    func fetchPokemon(url:String, completion: @escaping (Pokemon)-> Void){
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
                guard error == nil,let data = data else{return}
                do{
                    let fetchedPokemon = try self.decoder.decode(APIPokemonResult.self, from: data)
                    //fetch picture-----------------------------------------
                    var fetchedImg:UIImage?
                    self.fetchImg(url: fetchedPokemon.sprites.front_default){img in
                        fetchedImg = img
                    }
                    //create pokemon object---------------------------------
                    let dic = ["image": fetchedImg ,"name": fetchedPokemon.name, "weight": fetchedPokemon.weight, "height": fetchedPokemon.height,"baseExperience":fetchedPokemon.base_experience,"attack": fetchedPokemon.stats[1].base_stat, "defense":fetchedPokemon.stats[4].base_stat] as [String : Any]
                    let pokemon = Pokemon(id: fetchedPokemon.id, dictionary: dic)
                    //add object to array with all pokemons and return with completion
                    self.pokemons.append(pokemon)
                    DispatchQueue.main.async {
                        completion(pokemon)
                    }
                }
                catch let error{
                    print("Error fetching pokemon: \(error.localizedDescription)")
                }
            }).resume()
        }
    }
                               
    func fetchImg(url:String, completion: @escaping (UIImage)-> Void){
    
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url){ data,_,error in
                guard error == nil, let data = data else{return}
                DispatchQueue.main.async {
                    if let img = UIImage(data: data){
                        completion(img)
                    }else{
                        completion(UIImage())
                    }
                }
                
            }.resume()
        }
    
    }
}
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
