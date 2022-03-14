//
//  Pokemon.swift
//  Pokedex
//
//  Created by Julia Tankiewicz on 09/03/2022.
//

import Foundation
import UIKit

class Pokemon{
    
        var id: Int?
        var name: String?
        var imageUrl: String?
        var image: UIImage?
        var weight: Int?
        var height: Int?
        var defense: Int?
        var attack: Int?
        var description: String?
        var species: String?
        var baseExperience: Int?
        
    init(id: Int, dictionary: [String: Any]){
            
            self.id = id
            
            if let name = dictionary["name"] as? String{
                self.name = name
            }
            if let imageUrl = dictionary["imageUrl"] as? String{
                self.imageUrl = imageUrl
            }
            if let image = dictionary["image"] as? UIImage{
                self.image = image
            }
            if let weight = dictionary["weight"] as? Int{
                self.weight = weight
            }
            if let height = dictionary["height"] as? Int{
                self.height = height
            }
            if let defense = dictionary["defense"] as? Int{
                self.defense = defense
            }
            if let attack = dictionary["attack"] as? Int{
                self.attack = attack
            }
            if let description = dictionary["description"] as? String{
                self.description = description
            }
            if let species = dictionary["species"] as? String{
                self.species = species
            }
            if let baseExperience = dictionary["baseExperience"] as? Int{
                self.baseExperience = baseExperience
            }
            
        }
    
}

